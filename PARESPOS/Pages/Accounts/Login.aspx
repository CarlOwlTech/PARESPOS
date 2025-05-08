<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="PARESPOS.Pages.Accounts.Login" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <!-- CSS references -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#E56441',
                        secondary: '#A8A8AC',
                        background: '#f7f7f7',
                        success: '#10B981',
                        warning: '#F59E0B',
                        danger: '#EF4444'
                    }
                }
            }
        }
    </script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" />
</head>
<body class="bg-background min-h-screen flex flex-col">
    <form id="form1" runat="server">
        <div class="fixed inset-0 bg-background flex items-center justify-center z-50">
            <div class="bg-white p-8 rounded-lg shadow-lg w-96">
                <div class="text-center mb-6">
                    <i class="fas fa-cash-register text-primary text-4xl mb-2"></i>
                    <h1 class="text-2xl font-bold text-gray-800">POS System</h1>
                    <p class="text-gray-500">Sign in to continue</p>
                </div>
                
                <div class="space-y-4">
                    <div>
                        <label for="username" class="block text-sm font-medium text-gray-700">Username</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary" />
                    </div>
                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary" />
                    </div>
                    
                    <asp:Button ID="btnLogin" runat="server" Text="Sign in" OnClick="btnLogin_Click" 
                        CssClass="w-full cursor-pointer flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary" />
                    
                    <asp:Label ID="lblErrorMessage" runat="server" CssClass="text-danger text-sm" Visible="false"></asp:Label>
                </div>
            </div>
        </div>
    </form>
</body>
</html>