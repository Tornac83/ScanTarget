--[[
* Ashita - Copyright (c) 2014 - 2022 atom0s [atom0s@live.com]
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
* Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*
* By using Ashita, you agree to the above license and its terms.
*
*      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
*                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
*                    endorses you or your use.
*
*   Non-Commercial - You may not use the material (Ashita) for commercial purposes.
*
*   No-Derivatives - If you remix, transform, or build upon the material (Ashita), you may not distribute the
*                    modified material. You are, however, allowed to submit the modified works back to the original
*                    Ashita project in attempt to have it added to the original project.
*
* You may not apply legal terms or technological measures that legally restrict others
* from doing anything the license permits.
*
* No warranties are given.
]]--

_addon.author   = 'Framework by Atom0s modified by Tornac';
_addon.name     = 'ScanTarget';
_addon.version  = '1.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- func: print_help
-- desc: Displays a help block for proper command usage.
----------------------------------------------------------------------------------------------------
local function print_help(cmd, help)
    -- Print the invalid format header..
    print('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\68Invalid format for command:\30\02 ' .. cmd .. '\30\01'); 

    -- Loop and print the help commands..
    for k, v in pairs(help) do
        print('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\68Syntax:\30\02 ' .. v[1] .. '\30\71 ' .. v[2]);
    end
end

----------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Called when a packet is recived.
----------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, packet, packet_modified, blocked)
	if id == 0x0F5 then
		Message = struct.unpack('I4', packet, 0x14+0x01);
		if Message == 2 then
			print('Widescan Target is dead.');
			WidescanTrack = false
		end
	end
	return false;
end);
----------------------------------------------------------------------------------------------------
-- func: outgoing_packet
-- desc: Called when a packet goes out.
----------------------------------------------------------------------------------------------------
ashita.register_event('outgoing_packet', function(id, size, packet, packet_modified, blocked)
	if id == 0x0F5 then --Widescan Track.
		print('Widescan Target Aquired.') 
		WidescanTrack = true
	end
	if id == 0x0F6 then --Widescan Track.
		print('Widescan Target Canceled.') 
		WidescanTrack = false
	end
 	return false;
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------

ashita.register_event('command', function(command, ntype)
    -- Get the arguments of the command..
    local args = command:args();
    if (args[1] ~= '/scantarget') then
        return false;
    end

    -- Toggle the Sublimation visibility..
    if (#args == 3) then
        if WidescanTrack == true then
			--print('' .. args[2] .. '' .. ' ' .. '"' .. args[3] .. '" <scan>')
			AshitaCore:GetChatManager():QueueCommand('' .. args[2] .. '' .. ' ' .. '"' .. args[3] .. '" <scan>', 1);
		end
        return true;
    end

    -- Prints the addon help..
    print_help('/scantrack', {
        { '/scantrack args[2] args[3]',                  '- ex. /scantrack /ma flash.' },
    });
    return true;
end);