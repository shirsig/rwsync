# rwsync - WoW 1.12 addOn

## Commands
**/rwsync players _namelist_** (**namelist** is a comma separated list of player names (e.g., **someplayer,otherplayer,hildebeast**) whose raid warnings should be replicated)<br/>
**/rwsync channel _channelname_** (Sets the channel to be used by the addOn to communicate with other people's addOns)<br/>
**/rwsync** (Prints configured players and channel)

Note that all participants need to have joined the channel.

Detailed steps:

Goal: There are two raid leaders, Trump and Pence, and Pence should replicate all of Trump's raid warnings.

Steps:
1) Trump and Pence both install the addon
2) Trump and Pence both join the chosen channel: /join usa
3) Trump and Pence both configure their channel: /rwsync channel usa
3) Pence adds Trump to his players list: /rwsync players trump
4) Trump makes a raid warning in his raid: **maga**
5) Trump's addon generates an automatic message on channel testchannel: **maga**
6) Pence's addon receives the message and generates an automatic raid warning: **Trump: maga**
