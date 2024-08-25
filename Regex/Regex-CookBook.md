# Regex CookBook #

### **Commonly Used Regex Patterns**

#### **Email Validation**
   - **Basic Pattern**: `^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,6}$`
   - **Examples**:
     - Matches: `john.doe@example.com`, `jane-doe@sub.domain.org`
     - Does not match: `john.doe@com`, `john@doe@domain.com`
   - **Extended Pattern (More Strict)**: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
   - **Usage**: Ensures a more strictly formatted email address.

#### **URL Validation**
   - **Basic Pattern**: `^https?:\/\/[^\s/$.?#].[^\s]*$`
   - **Examples**:
     - Matches: `http://example.com`, `https://www.example.com/path?query=123`
     - Does not match: `htp://example`, `http//example.com`
   - **With Optional Port**: `^https?:\/\/[^\s/$.?#].[^\s]*:\d{1,5}(\/[^\s]*)?$`
   - **With Query Strings**: `^https?:\/\/[^\s/$.?#].[^\s]*\?[^\s]*$`
   - **With Optional www**: `^https?:\/\/(www\.)?[^\s/$.?#].[^\s]*$`

#### **IPv4 Address**
   - **Basic Pattern**: `\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b`
   - **Examples**:
     - Matches: `192.168.1.1`, `10.0.0.1`
     - Does not match: `256.256.256.256`, `192.168.1`
   - **Valid Range**: `\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b`
     - **Usage**: Validates that each segment of the IP address is between 0 and 255.

#### **Date Format (Various)**
   - **YYYY-MM-DD**: `\b\d{4}-\d{2}-\d{2}\b`
     - **Examples**:
       - Matches: `2024-08-25`, `1990-01-01`
       - Does not match: `24-08-2024`, `1990/01/01`
   - **Flexible Date Matching**: `\b\d{4}[\/\-]\d{2}[\/\-]\d{2}\b`
     - **Usage**: Matches dates in both "YYYY-MM-DD" and "YYYY/MM/DD" formats.
   - **MM/DD/YYYY**: `\b\d{2}\/\d{2}\/\d{4}\b`
     - **Usage**: Matches dates in the format "MM/DD/YYYY".
   - **DD/MM/YYYY**: `\b\d{2}\/\d{2}\/\d{4}\b`
     - **Usage**: Matches dates in the format "DD/MM/YYYY".

#### **Hex Color Code**
   - **Basic Pattern**: `#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3})`
     - **Examples**:
       - Matches: `#FFFFFF`, `#FFF`, `FFFFFF`, `fff`
       - Does not match: `#FFFF`, `#12345g`
   - **Strict Hex Color Validation**: `^#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$`
     - **Usage**: Ensures that the color code starts with a `#` and is either 3 or 6 digits long.
   - **RGBA Color Code**: `^rgba?\(\d{1,3},\d{1,3},\d{1,3}(?:,\d?\.?\d+)?\)$`
     - **Usage**: Matches rgba color codes like `rgba(255,255,255,0.5)`.

#### **US Phone Number**
   - **Basic Pattern**: `\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}`
     - **Examples**:
       - Matches: `(123) 456-7890`, `123-456-7890`, `123.456.7890`, `123 456 7890`
       - Does not match: `12345-6789`, `123-4567-890`
   - **With Country Code**: `\+1[-.\s]?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}`
     - **Usage**: Matches US phone numbers with a country code, e.g., `+1 (123) 456-7890`.
   - **International Format**: `\+\d{1,3}[-.\s]?\(?\d{1,4}\)?[-.\s]?\d{1,4}[-.\s]?\d{1,4}[-.\s]?\d{1,9}`
     - **Usage**: Matches international phone numbers like `+44 1234 567 890`.

#### **Extracting All Words**
   - **Basic Pattern**: `\b\w+\b`
     - **Examples**:
       - Matches: Extracts "hello", "world" from "hello world!"
       - Does not match: Non-word characters like punctuation.
   - **Including Apostrophes**: `\b[\w']+\b`
     - **Usage**: Matches words like "can't", "won't".
   - **Extracting Words with Hyphens**: `\b[\w-]+\b`
     - **Usage**: Matches hyphenated words like "mother-in-law".

#### **Remove HTML Tags**
   - **Basic Pattern**: `<[^>]+>`
     - **Examples**:
       - Matches: `<div>`, `</p>`, `<a href="#">`
       - Does not match: Text outside of tags.
   - **Extracting Text from HTML**: `>([^<]+)<`
     - **Usage**: Captures text between HTML tags.
   - **Remove Specific Tags**: `<(div|p|a)[^>]*>.*?<\/\1>`
     - **Usage**: Matches specific HTML tags like `<div>`, `<p>`, or `<a>`.

#### **Extracting Domains from URLs**
   - **Basic Pattern**: `https?:\/\/(www\.)?([a-zA-Z0-9.-]+)\.[a-zA-Z]{2,6}`
     - **Examples**:
       - Matches: Extracts `example.com` from `https://www.example.com/page?query=123`
       - Does not match: Malformed URLs like `http:/example.com`.
   - **Extracting Subdomains**: `https?:\/\/([a-zA-Z0-9.-]+\.)?([a-zA-Z0-9.-]+)\.[a-zA-Z]{2,6}`
     - **Usage**: Captures subdomains along with the main domain.
   - **Extracting Top-Level Domain**: `https?:\/\/([a-zA-Z0-9.-]+)\.(com|org|net|edu|gov)`
     - **Usage**: Captures the top-level domain.

#### **Password Validation**
   - **Basic Pattern**: `^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$`
     - **Examples**:
       - Matches: `Passw0rd!`, `Secure123$`
       - Does not match: `password`, `PASSWORD123`, `Pass1234`
   - **Strict Validation (12+ Characters)**: `^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{12,}$`
   - **No Special Character Required**: `^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$`
     - **Usage**: Matches passwords without requiring a special character.

#### **Postal Code Validation**
   - **US ZIP Code**:
     - **Pattern**: `^\d{5}(?:-\d{4})?$`
     - **Examples**:
       - Matches: `12345`, `12345-6789`
       - Does not match: `1234`, `123456789`
   - **Canadian Postal Code**:
     - **Pattern**: `^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$`
     - **Examples**:
       - Matches: `K1A 0B1`, `B1Z 2R4`
       - Does not match: `123

45`, `K1A0B1Z`
   - **UK Postcode**:
     - **Pattern**: `^(GIR 0AA|[A-Z]{1,2}\d[A-Z\d]? \d[A-Z]{2})$`
     - **Examples**:
       - Matches: `EC1A 1BB`, `W1A 0AX`, `M1 1AE`
       - Does not match: `12345`, `EC1A-1BB`

#### **Currency Validation**
   - **US Dollar**:
     - **Pattern**: `^\$?(\d{1,3})(,\d{3})*(\.\d{2})?$`
     - **Examples**:
       - Matches: `$1,234.56`, `1234.56`, `$1,000`
       - Does not match: `1,234.567`, `1234,56`
   - **Euro Currency**:
     - **Pattern**: `^€?(\d{1,3})(\.\d{3})*(,\d{2})?$`
     - **Usage**: Matches Euro currency format, e.g., `€1.234,56`.
   - **Pound Sterling**:
     - **Pattern**: `^£?(\d{1,3})(,\d{3})*(\.\d{2})?$`
     - **Usage**: Matches GBP currency format, e.g., `£1,234.56`.

#### **Time Validation**
   - **24-Hour Time**:
     - **Pattern**: `^([01]\d|2[0-3]):[0-5]\d$`
     - **Examples**:
       - Matches: `14:30`, `23:59`, `00:00`
       - Does not match: `24:00`, `14:60`
   - **12-Hour Time with AM/PM**:
     - **Pattern**: `^(1[0-2]|0?[1-9]):[0-5]\d ?([AaPp][Mm])$`
     - **Examples**:
       - Matches: `2:30 PM`, `12:59 AM`, `01:00 pm`
       - Does not match: `14:30 PM`, `13:00 AM`

#### **Credit Card Number Validation**
   - **Basic Pattern (Visa, MasterCard, etc.)**:
     - **Pattern**: `\b(?:\d{4}[- ]?){3}\d{4}\b`
     - **Examples**:
       - Matches: `1234 5678 1234 5678`, `1234-5678-1234-5678`, `1234567812345678`
       - Does not match: `1234 567 1234 5678`, `1234-5678-12345-678`
   - **Luhn Algorithm Check**:
     - **Pattern**: `^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|6(?:011|5[0-9]{2})[0-9]{12}|(?:2131|1800|35\d{3})\d{11})$`
     - **Usage**: Matches and validates credit card numbers using the Luhn algorithm.

#### **Matching File Extensions**
   - **Basic Pattern**:
     - **Pattern**: `^.+\.(jpg|jpeg|png|gif|bmp)$`
     - **Examples**:
       - Matches: `image.jpg`, `photo.png`, `icon.gif`
       - Does not match: `document.txt`, `file.jpegx`
   - **Matching Any Extension**:
     - **Pattern**: `^.+\.\w{2,4}$`
     - **Usage**: Matches any file with a 2 to 4 character extension.
   - **Specific Extensions (e.g., Docs)**:
     - **Pattern**: `^.+\.(doc|docx|pdf|txt)$`
     - **Usage**: Matches files like `document.doc`, `report.pdf`, `notes.txt`.

#### **Extracting HTML Comments**
   - **Pattern**: `<!--(.*?)-->`
   - **Examples**:
     - Matches: Extracts ` This is a comment ` from `<!-- This is a comment -->`.
     - Does not match: Text outside of comments.

#### **Matching URLs in Text**
   - **Pattern**: `https?:\/\/[^\s]+`
   - **Examples**:
     - Matches: `http://example.com`, `https://www.example.com`
     - Does not match: Non-URL text or URLs with spaces.
   - **With Query Parameters**:
     - **Pattern**: `https?:\/\/[^\s]+\?[^\s]*`
     - **Usage**: Matches URLs with query parameters like `https://example.com?query=123`.

#### **Extracting Email Addresses**
   - **Pattern**: `[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,6}`
   - **Examples**:
     - Matches: Extracts `john.doe@example.com` from text.
     - Does not match: Malformed email addresses.

#### **Social Security Number (SSN) Validation**
   - **Pattern**: `^\d{3}-\d{2}-\d{4}$`
   - **Examples**:
     - Matches: `123-45-6789`
     - Does not match: `123456789`, `12-3456-789`
   - **Strict Validation**:
     - **Pattern**: `^(?!000|666|9\d\d)\d{3}-(?!00)\d{2}-(?!0000)\d{4}$`
     - **Usage**: Ensures the SSN does not contain invalid numbers.

#### **Extracting Hashtags from Text**
   - **Pattern**: `#\w+`
   - **Examples**:
     - Matches: Extracts `#hashtag` from `This is a #hashtag in text.`
     - Does not match: Text without hashtags.
   - **Strict Hashtag Matching**:
     - **Pattern**: `\B#\w\w+`
     - **Usage**: Matches hashtags that are not preceded by a word character.

#### **Extracting Mentions (e.g., @username)**
   - **Pattern**: `@\w+`
   - **Examples**:
     - Matches: Extracts `@username` from `Message to @username.`
     - Does not match: Text without mentions.
   - **Strict Mention Matching**:
     - **Pattern**: `\B@\w\w+`
     - **Usage**: Matches mentions that are not preceded by a word character.

#### **Extracting IP Addresses from Text**
   - **Pattern**: `\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b`
   - **Examples**:
     - Matches: Extracts `192.168.1.1` from text.
     - Does not match: Invalid IPs like `256.256.256.256`.

#### **Extracting Dates from Text**
   - **Pattern**: `\b\d{4}-\d{2}-\d{2}\b`
   - **Examples**:
     - Matches: Extracts `2024-08-25` from text.
     - Does not match: Malformed dates like `24-08-2024`.

#### **Extracting MAC Addresses**
   - **Pattern**: `([A-Fa-f0-9]{2}:){5}[A-Fa-f0-9]{2}`
   - **Examples**:
     - Matches: Extracts `00:1A:2B:3C:4D:5E` from text.
     - Does not match: Invalid MAC addresses like `00:1A:2B:3C:4D`.

#### **Extracting Version Numbers**
   - **Pattern**: `\bv?(\d+\.)+\d+\b`
   - **Examples**:
     - Matches: Extracts `v1.2.3` or `2.3.4` from text.
     - Does not match: Non-numeric versions like `v1.2a`.

#### **Matching JavaScript Object Keys**
   - **Pattern**: `\b\w+(?=\s*:)`
   - **Examples**:
     - Matches: Extracts `key` from `key: "value"`.
     - Does not match: Keys without colons.
