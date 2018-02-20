![logo](https://image.ibb.co/ddRBhc/Ma_Sp_X_widow_shield.png "MaSpX logo")

# MaSpX Overview
Webserver with code formally proven by [the SPARK toolset](http://www.spark-2014.org/), granting it unique invulnerabilities to common attacks. Sister project to [Ironsides DNS](http://ironsides.martincarlisle.com/).

We plan to release MaSp in four main releases: MaSp0.9, MaSp1, MaSp1.1 and MaSp2, corresponding to each of the major versions of [HTTP](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol). Other features will be added to MaSpX as development progresses, features such as those seen in the feature matrix on [Wikipedia's comparison of web servers](https://en.wikipedia.org/wiki/Comparison_of_web_server_software#Features).

MaSp might seem like a strange name, but it is the name of the two chief proteins (MaSp1 & MaSp2) used by spiders to create dragline web. Spider silk, though naturally "gossamerish" has nearly the tensile strength of steel and is far more flexible. We envision MaSpX being a building block of a Web that is strong as steel but flexible enough to host the litany of applications already running on the web.

# Types of Bugs Inherently Rectified with Ada/SPARK
* Range Errors	 
  * Stack Overflow,	No vulnerability in SPARK
  * Heap Overflow,	No vulnerability in SPARK
  * Format String Vulnerability,	No vulnerability in SPARK
  * Improper Null Termination,	No vulnerability in SPARK
* API Abuse	 
  * Heap Inspection,	No vulnerability in SPARK
  * Often Misused: String Management,  	No vulnerability in SPARK
* Time and State	 
  * Unchecked Error Condition,	No vulnerability in SPARK
* Code Quality	 
  * Memory Leak,	No vulnerability in SPARK
  * Double Free,	No vulnerability in SPARK
  * Use After, Free	No vulnerability in SPARK
  * Uninitialized Variable,	No vulnerability in SPARK
  * Unintentional Pointer Scaling,	No vulnerability in SPARK
  * Null Dereference,  No vulnerability in SPARK
  
In Apache 2.4, about 50% of security vulnerabilties are caused by the bugs listed above. The other 50% are design or implementation bugs.
