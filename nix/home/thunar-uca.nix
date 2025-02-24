{ config-vars, ... }:

{
  home.file = {
    ".config/Thunar/uca.xml".text = # xml
      ''
        <?xml version="1.0" encoding="UTF-8"?>
        <actions>
        <action>
            <icon></icon>
            <name>Open Terminal Here</name>
            <submenu></submenu>
            <unique-id>1667782009341942-1</unique-id>
            <command>sh -c &quot;cd %f ; ${config-vars.terminal}&quot;</command>
            <description>Open a terminal in the current directory</description>
            <range></range>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
        </action>
        <action>
            <icon></icon>
            <name>FFProbe</name>
            <submenu></submenu>
            <unique-id>1676602598381730-1</unique-id>
            <command>${config-vars.terminal} -e &quot;ffprobe -hide_banner %f 2&gt;&amp;1 | less --exit-follow-on-close +F&quot;</command>
            <description>Run ffprobe on file</description>
            <range>*</range>
            <patterns>*</patterns>
            <audio-files/>
            <video-files/>
        </action>
        <action>
            <icon></icon>
            <name>MediaInfo</name>
            <submenu></submenu>
            <unique-id>1690139417393646-2</unique-id>
            <command>${config-vars.terminal} -e &quot;mediainfo %f 2&gt;&amp;1 |  less  --exit-follow-on-close +F&quot;</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <video-files/>
        </action>
        <action>
            <icon></icon>
            <name>Normalize</name>
            <submenu></submenu>
            <unique-id>1731643961229000-1</unique-id>
            <command>${config-vars.home-dir}/Dev/videoman/src/index.ts normalize --notify %f</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <video-files/>
        </action>
        <action>
            <icon></icon>
            <name>Cull</name>
            <submenu>picman</submenu>
            <unique-id>1689641415278067-1</unique-id>
            <command>${config-vars.home-dir}/Dev/picman/src/cull-basic.ts %F 2&gt;&amp;1 &gt; /tmp/cull_logs.log</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <image-files/>
        </action>
        <action>
            <icon></icon>
            <name>Cull (safe)</name>
            <submenu>picman</submenu>
            <unique-id>1719774323493242-2</unique-id>
            <command>${config-vars.home-dir}/Dev/picman/src/cull-basic.ts --safe %F 2&gt;&amp;1 &gt; /tmp/cull_logs.log</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <image-files/>
        </action>
        <action>
            <icon></icon>
            <name>Import images/videos</name>
            <submenu></submenu>
            <unique-id>1689902676394518-1</unique-id>
            <command>${config-vars.terminal} -e &apos;${config-vars.home-dir}/Dev/picman/src/sd-import.ts %f | less  --exit-follow-on-close +F&apos;</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <directories/>
        </action>
        <action>
            <icon></icon>
            <name>View Metadata</name>
            <submenu>picman</submenu>
            <unique-id>1690136297179459-1</unique-id>
            <command>${config-vars.terminal} -e &apos;exiv2 -p a %f 2&gt;&amp;1 | rg -v &quot;MakerNote|XMLPacket&quot; | less  --exit-follow-on-close +F&apos;</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <image-files/>
        </action>
        <action>
            <icon></icon>
            <name>Anonymize</name>
            <submenu>picman</submenu>
            <unique-id>1690485195569083-1</unique-id>
            <command>${config-vars.home-dir}/Dev/picman/src/anonymize.ts %F</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <image-files/>
        </action>
        <action>
            <icon></icon>
            <name>Make Private</name>
            <submenu>picman</submenu>
            <unique-id>1719616786472408-1</unique-id>
            <command>${config-vars.home-dir}/Dev/picman/src/private.ts %F 2&gt;&amp;1 &gt; /tmp/privatize.log</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <image-files/>
        </action>
        <action>
            <icon></icon>
            <name>Make Pano Folder</name>
            <submenu>picman</submenu>
            <unique-id>1719760172570658-1</unique-id>
            <command>${config-vars.home-dir}/Dev/picman/src/pano-group.ts %F 2&gt;&amp;1 &gt; /tmp/pano-group.log</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <image-files/>
        </action>
        <action>
            <icon></icon>
            <name>Set GPS Location</name>
            <submenu>picman</submenu>
            <unique-id>1720814069760259-1</unique-id>
            <command>${config-vars.home-dir}/Dev/picman/src/gps.ts --write-gps %F</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <image-files/>
        </action>
        <action>
            <icon></icon>
            <name>Open GPS Location</name>
            <submenu>picman</submenu>
            <unique-id>1720819178080678-2</unique-id>
            <command>${config-vars.home-dir}/Dev/picman/src/gps.ts --open-gps %F</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <image-files/>
        </action>
        <action>
            <icon></icon>
            <name>Correlate GPS</name>
            <submenu>picman</submenu>
            <unique-id>1722097833051003-1</unique-id>
            <command>${config-vars.home-dir}/Dev/picman/src/gps.ts --correlate-gps %F</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <image-files/>
        </action>
        </actions>
      '';
  };
}
