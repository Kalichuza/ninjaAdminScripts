Below are the in-depth instructions for setting up Jupyter Notebook in Visual Studio Code (VS Code) on Windows and configuring it to use PowerShell as the kernel.

### Step 1: Install Visual Studio Code

1. **Download VS Code**:
   - Go to the [official Visual Studio Code website](https://code.visualstudio.com/).
   - Click on the download link for Windows and run the installer.

2. **Install VS Code**:
   - Follow the installation prompts. You can keep the default settings, but you may want to check the options to add VS Code to your system PATH for easier command line usage.

### Step 2: Install Python

1. **Download Python**:
   - Go to the [official Python website](https://www.python.org/downloads/).
   - Download the latest stable version of Python for Windows.

2. **Install Python**:
   - Run the installer.
   - IMPORTANT: Check the box that says "Add Python to PATH" before clicking "Install Now."
   - Follow the rest of the installation prompts.

3. **Verify Python Installation**:
   - Open a new Command Prompt or PowerShell window and type:
     ```powershell
     python --version
     ```
   - You should see the installed Python version.

### Step 3: Install Jupyter Notebook

1. **Install Jupyter Notebook via pip**:
   - Open a Command Prompt or PowerShell window.
   - Install Jupyter Notebook by running:
     ```powershell
     pip install notebook
     ```

2. **Verify Installation**:
   - After installation, you can verify Jupyter is installed by typing:
     ```powershell
     jupyter notebook --version
     ```
   - This should return the version number of Jupyter Notebook installed.

### Step 4: Install the Jupyter and Python Extensions in VS Code

1. **Open VS Code**:
   - Launch Visual Studio Code.

2. **Install the Python Extension**:
   - Click on the Extensions icon in the Activity Bar on the side of the window (or press `Ctrl+Shift+X`).
   - Search for "Python" and install the extension provided by Microsoft.

3. **Install the Jupyter Extension**:
   - While still in the Extensions view, search for "Jupyter" and install the extension provided by Microsoft.

### Step 5: Install PowerShell Kernel for Jupyter

1. **Install .NET SDK**:
   - To use PowerShell as a kernel in Jupyter, you'll need the .NET SDK. Download and install it from the [official .NET SDK website](https://dotnet.microsoft.com/download).

2. **Install PowerShell Kernel**:
   - After installing the .NET SDK, open a PowerShell window and run the following commands to install the PowerShell kernel for Jupyter:
     ```powershell
     dotnet tool install -g Microsoft.dotnet-interactive
     dotnet interactive jupyter install
     ```
   - This will install the PowerShell kernel and set it up for use in Jupyter.

### Step 6: Create a New Jupyter Notebook in VS Code


1. **Open VS Code**:
   - Open Visual Studio Code.
   - In an admin Powershell portal, type:
   ```powershell
   jupyter notebok
   ```
   - This will give you several urls. Copy and past one into the existing server in the kernal dropdown menu at the top of the project screen in the search bar.
2. **Create a New Jupyter Notebook**:
   - Open the Command Palette by pressing `Ctrl+Shift+P`.
   - Type "Jupyter: Create New Blank Notebook" and press Enter.
   - Choose the PowerShell kernel when prompted.

3. **Save the Notebook**:
   - Save the notebook with a `.ipynb` extension.

4. **Add and Run Cells**:
   - You can now add code cells in PowerShell, write scripts, and execute them directly within the notebook.

### Step 7: Open and Edit Existing Notebooks

1. **Open an Existing Notebook**:
   - Drag and drop an existing `.ipynb` file into VS Code, or use `File -> Open File` to select and open a notebook.

2. **Switch Kernel**:
   - If your notebook is not already using PowerShell, you can switch the kernel by clicking on the kernel name in the top right corner of the notebook and selecting "PowerShell".

### Step 8: Use VS Code for Interactive PowerShell Development

1. **Run Cells**:
   - Run individual cells by clicking the play button next to each cell, or run all cells by clicking `Run All` at the top of the notebook.

2. **Variable Explorer**:
   - Use the variable explorer provided by the Jupyter extension to view and interact with variables in your PowerShell environment.

3. **Debugging**:
   - VS Code allows you to set breakpoints and debug your PowerShell scripts within the notebook.

### Step 9: Share and Collaborate

1. **Save and Share**:
   - Save your notebook and share the `.ipynb` file with others. They can open it in VS Code or any Jupyter-compatible environment.

2. **Export to Other Formats**:
   - You can export the notebook to other formats like HTML, PDF, or a Python script by using the `File -> Export` option within the notebook interface.

### Conclusion

You now have a fully integrated setup in VS Code to create, edit, and run Jupyter notebooks using PowerShell. This setup is powerful for development, testing, and documenting PowerShell scripts interactively.
