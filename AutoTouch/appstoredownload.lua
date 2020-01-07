--------------------------------------
-- Information of recording
-- Time: 2019-07-10 02:04:56
-- Resolution: 750, 1334
-- Orientation of front most app: Portrait;
--------------------------------------

-- Implement a tap function
function tap(x, y)
    touchDown(0, x, y);
    usleep(16000);
    touchUp(0, x, y);
end

-- Detect image
function detectImage(filename, threshold, method)
    local result = findImage(filename, 1, threshold, nil, false, method);
    for i, v in pairs(result) do
    	return v[1], v[2];
	end
	return nil
end

-- Output
function writeOutputResult(returnCode)
    io.popen("cd /private/var/mobile/Documents/ && mkdir -p AutoTouch");
	usleep(500000); -- wait 0.5 sec
	local file = io.open("/private/var/mobile/Documents/AutoTouch/result.txt", "w");
	if file == nil then
		--toast("Could not open file...");
		return
	else
		file:write(returnCode);
		file:close();
		--toast("wrote result --> " .. returnCode);
	end
end

function main()
	local result = 0;
	-- Try Cloud button
	local cloudButtonX, cloudButtonY = detectImage("images/cloud.png", 0.99, 1);
	if cloudButtonX == nil then
		-- Try GET button
		local getButtonX, getButtonY = detectImage("images/get.png", 0.9, 1);
		if getButtonX == nil then
			-- Found no button
			--toast("could not find any button, aborting...");
			result = 1;
		else
			-- Found get button
			--toast("Found get button! Tapping...");
			--log(getButtonX, getButtonY);
			tap(getButtonX, getButtonY);
			
			usleep(5500000); -- wait 5.5 sec
			
			-- Try Install button
			local installButtonX, installButtonY = detectImage("images/install.png", 0.9, 1);
			if installButtonX == nil then
				-- Found no button
				--toast("could not find install button, aborting...");
				result = 1;
			else
				-- Found install button
				--toast("Found install button! Tapping...");
				tap(installButtonX, installButtonY);
			end
		end
	else
		-- Found cloud button
		--toast("Found cloud button! Tapping...");
		tap(cloudButtonX, cloudButtonY);
	end
	
	writeOutputResult(result);
end

main();