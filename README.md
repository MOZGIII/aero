Aero
====

This is a small educational project. Pass by if you do not know what it is about.


Usage (newbie guide)
--------------------

### Prerequisites

You need to have Ruby and VirtualBox installed to your local machine.

You will also need a vagrant gem, so run `[sudo] gem install vagrant`.

If you're using Windows, you will also require to install SSH client (like PuTTY).

When you have all of the above, you are ready to begin your work.

### To begin with

Clone this repo and `cd` into it. Then do `vagrant up`.

	cd aero/
	vagrant up

For the first time it will download and deploy virtual machine, it can take some time.

After that you will see something like
	
	...
	[default] Forwarding ports...
	[default] -- 22 => 2222 (adapter 1)
	[default] -- 80 => 8080 (adapter 1)
	[default] Creating shared folders metadata...
	[default] Clearing any previously set network interfaces...
	[default] Booting VM...
	[default] Waiting for VM to boot. This can take a few minutes.
	[default] VM booted and ready for use!
	[default] Mounting shared folders...
	[default] -- v-root: /vagrant

And this means you're ready to go!

### Development

You can now visit http://127.0.0.1:8080/cgi-bin/vagrant/aero/aero.rb and see your aero up and running!

To access the command line of the server use ssh at `vagrant@127.0.0.1:2222` with password `vagrant`.
If you are not on Windows you can use `vagrant ssh` to connect to ssh automatically.
If you're on Windows, configure PuTTY to `vagrant@127.0.0.1` with port `2222` and use Vagrant PuTTY key: http://dl.dropbox.com/u/38311510/vagrant/key.ppk.

PS: you can import my PuTTY config from here: http://dl.dropbox.com/u/38311510/vagrant/putty.reg.

### Finishing

When you're done, use `sudo poweroff` from within the VM or use `vagrant halt` at the host.
