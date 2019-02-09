<h1>CN5103 - Operating Systems - University of East London</h1>
<h2>Brief</h2>
You are required to program TWO shell scripts, one which executes in a UNIX environment and one which executes in a Windows environment.
Your scripts must satisfy the following requirements:

1.	They must perform an operating system routine, which is based on a useful system administration function.

2.	They may be written in whatever shell scripting language you choose, as long as you do not use the same scripting language for both the Unix and Windows scripts.

3.	You may use examples of scripts that you find in printed documentation and on the Web as the starting point for your own scripts.

You will be required to demonstrate your work towards the end of the module at a time to be specified by the module leader via Moodle.

<h2>Our Submission</h2>
<a href="https://github.com/Bartolus99/L5_OS_Coursework/tree/Submitted">Here</a> you will find a branch at the state the Repo was in when we submitted our work. <p>
The Master branch continues to be developed for fun.

<h1> Windows Backup Script </h1>
by Josh Button

What is it?<p>
A Powershell script with a GUI for scheduling and configuring backups and restorating files.
  
<h2>Includes</h2>
<ul>
  <li>Check boxes to choose which folder to back up</li>
  <li>Two custom paths to backup</li>
  <li>Choose folder to back up to</li>
  <li>Backup to ZIP File</li>
  <li>Restore from ZIP File</li>
</ul>

<h2>Noteable script logic</h2>
<ul>

</ul>
<br />
<h1> UNIX Security Script </h1>
by Bartolus99

What is it?
A Bash script for Security stuff on Linux!

<h2>Includes</h2>
<ul>
  <li>Blocking blacklisted IP addresses</li>
  <li>Generating secure passwords</li>
  <li>Checking password strength</li>
  <li>File encryption</li>
  <li>File decryption</li>
</ul>
<h2>Noteable script logic</h2>
<ul>
  <li>Main menu calls script files, depending on chosen option.</li>
  <li>IP blocker downloads blacklist from <a href="http://myip.ms/files/blacklist/htaccess/latest_blacklist.txt">myip.ms</a> and saves log in <code>./unix/src/menus/ip/logs</code>.</li>
  <li>Password generator allows the user to choose if lower/uppercase alphanumeric characters or special characters, based on <a href="https://www.ibm.com/support/knowledgecenter/en/SSFPJS_8.5.7/com.ibm.wbpm.imuc.doc/topics/rsec_characters.html">IBM's valid username/password character list</a>, should be used.</li>
  <li>Password checker adds to the complexity score, based on the password length, and variation of lower/uppercase letters and numbers.</li>
  <li>File encryption/decryption uses <a href="https://www.gnupg.org/">GNU Privacy Guard</a>, A.K.A. <code>gpg</code>.</li>
</ul>
<br />
<h1>Resources</h1>
<ul>
  <li><a href="ideas.md">Ideas</a></li>
  <li><a href="folder-structure.md">Folder Structure</a></li>
</ul>
