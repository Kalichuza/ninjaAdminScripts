### Basic Syntax for Using .NET Namespace Objects

1. **Accessing a .NET Class**:
   In PowerShell, you can reference a .NET class by using its full namespace path.

   ```powershell
   [Namespace.Class]::Method()
   ```

   - **Namespace**: This is the hierarchical structure that organizes classes and types in .NET (e.g., `System`, `Microsoft.Win32`).
   - **Class**: This is the specific type you want to use (e.g., `String`, `Registry`, `FileInfo`).
   - **Method/Property**: You access static methods or properties using `::`.

2. **Creating an Instance of a .NET Class**:
   When working with classes that aren't static, you need to create an instance (object) of the class using `New-Object` or a type accelerator `[Namespace.Class]`.

   ```powershell
   $object = New-Object Namespace.Class
   ```

   or

   ```powershell
   $object = [Namespace.Class]::new()
   ```

   - **New-Object**: PowerShell’s cmdlet to create an instance of a .NET class.
   - **::new()**: This is the shortcut in PowerShell 5.1 and above to create a new object from a .NET class.

3. **Calling Methods and Accessing Properties**:
   Once you have created an instance of a .NET object, you can call methods and access properties using the `.` (dot) notation.

   ```powershell
   $object.MethodName()
   $object.PropertyName
   ```

### Detailed Breakdown

#### 1. Accessing Static Methods and Properties
Some .NET classes have static methods or properties, meaning you can call them without creating an instance of the class.

**Example**: Accessing a static property from the `System.DateTime` class:

```powershell
[System.DateTime]::Now
```

- **`[System.DateTime]`**: This is the .NET class. The square brackets tell PowerShell it's a .NET type.
- **`::Now`**: `Now` is a static property that returns the current date and time.

#### 2. Creating an Object (Instance)
To interact with non-static methods or properties, you need to create an object of the class.

**Example**: Creating an instance of `System.IO.FileInfo` to get information about a file:

```powershell
$fileInfo = New-Object System.IO.FileInfo("C:\path\to\file.txt")
$fileInfo.Length
$fileInfo.CreationTime
```

- **`New-Object System.IO.FileInfo`**: Creates an instance of the `FileInfo` class, passing in the file path as a constructor parameter.
- **`$fileInfo.Length`**: Accesses the `Length` property of the file to get its size.
- **`$fileInfo.CreationTime`**: Retrieves the file’s creation time.

Alternatively, in PowerShell 5.1 and above, you can use:

```powershell
$fileInfo = [System.IO.FileInfo]::new("C:\path\to\file.txt")
$fileInfo.Length
```

#### 3. Using Methods and Properties
Once you have an object, you can interact with its methods and properties just like in any object-oriented language.

**Example**: Working with a `System.Net.WebClient` object to download content from a URL.

```powershell
$webClient = New-Object System.Net.WebClient
$content = $webClient.DownloadString("https://example.com")
$content
```

- **`New-Object System.Net.WebClient`**: Creates a new instance of the `WebClient` class.
- **`DownloadString`**: Calls the `DownloadString` method to fetch data from a URL.

#### 4. Using Methods with Parameters
When calling methods that require parameters, you pass them in as you would in any other language.

**Example**: Converting a string to lowercase using `System.String.ToLower()`.

```powershell
$text = "HELLO"
$lowerText = $text.ToLower()
$lowerText
```

In this case, you don't even need to specify the `.NET` class because PowerShell automatically recognizes `$text` as a .NET `System.String` object.

### Putting It All Together: An Advanced Example
Let’s look at a more complex example where you use a non-static class, access properties, and call methods.

```powershell
# Create a new instance of the FileInfo class
$fileInfo = New-Object System.IO.FileInfo("C:\path\to\file.txt")

# Access properties of the FileInfo object
$length = $fileInfo.Length
$creationTime = $fileInfo.CreationTime

# Call a method on the FileInfo object
$fileInfo.Delete()

# Output the results
"File Size: $length bytes"
"Creation Time: $creationTime"
```

Here’s what’s happening:
- **`New-Object System.IO.FileInfo("C:\path\to\file.txt")`**: Creates an object representing a file.
- **`$fileInfo.Length`**: Retrieves the size of the file.
- **`$fileInfo.CreationTime`**: Retrieves the creation date of the file.
- **`$fileInfo.Delete()`**: Deletes the file by calling the `Delete` method.

### Conclusion
- **Static Methods/Properties**: Use `[Namespace.Class]::Method()` to access them.
- **Instance Methods/Properties**: Use `New-Object Namespace.Class` to create an object and interact with its methods and properties.
- **Type Accelerators**: In some cases, PowerShell provides short forms of .NET types (e.g., `[int]` for `System.Int32`, `[string]` for `System.String`).

