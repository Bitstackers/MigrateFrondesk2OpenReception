#!/bin/bash
mkdir output
mkdir output/ADM
mkdir output/AGENTS
mkdir output/CALENDAR
mkdir output/CALLBACK
mkdir output/CALLSTAT
mkdir output/COLORS
mkdir output/DS
mkdir output/EMAILS
mkdir output/ENDREASON
mkdir output/GROUPMEMBERS
mkdir output/GROUPS
mkdir output/LOG
mkdir output/MAILSSENT
mkdir output/MENUS
mkdir output/MSG
mkdir output/PARK
mkdir output/RECEPTIONS
mkdir output/REDIRNAMES
mkdir output/SENDMAILS
mkdir output/SHARE
mkdir output/STAT
mkdir output/STATERRORS
mkdir output/SUPERVISIONS
mkdir output/TAPIDEV
mkdir output/TRANSMSG
mkdir output/USERMENUS
mkdir output/WAVNAMES
mkdir output/WAVSETUP

isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/adm.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/agents.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/calendar.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/callback.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/callstat.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/colors.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/ds.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/emails.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/endreason.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/groupmembers.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/groups.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/log.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/mailssent.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/menus.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/msg.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/park.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/receptions.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/redirnames.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/sendmails.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/share.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/stat.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/staterrors.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/supervisions.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/tapidev.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/transmsg.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/usermenus.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/wavnames.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
isql-fb -u SYSDBA -p masterkey -i '/home/thomas/Migraring/ACS/wavsetup.sql' '/var/lib/firebird/2.5/data/ACSDATA.GDB'
