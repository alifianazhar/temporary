# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/StyxProject/manifest.git -b R -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/DHAMPOT/dependencies.git --depth=1 -b styx .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch styx_platina-userdebug
export SELINUX_IGNORE_NEVERALLOWS=true
export ALLOW_MISSING_DEPENDENCIES=true
export SKIP_API_CHECK=true
export SKIP_ABI_CHECK=true
export TZ=Asia/Jakarta
m styx-ota

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
