<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="PARESPOS.Pages.Accounts.Login" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PARES POS - Login</title>
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
                    },
                    fontFamily: {
                        'poppins': ['Poppins', 'sans-serif'],
                    },
                }
            }
        }
    </script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" />
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-image: url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTQ0MCIgaGVpZ2h0PSI3MjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PGxpbmVhckdyYWRpZW50IHgxPSI3MS42NCUiIHkxPSIxMC44OSUiIHgyPSI3MS42NCUiIHkyPSI4OS43OCUiIGlkPSJhIj48c3RvcCBzdG9wLWNvbG9yPSIjRjdGN0Y3IiBvZmZzZXQ9IjAlIi8+PHN0b3Agc3RvcC1jb2xvcj0iI0Y3RjdGNyIgb2Zmc2V0PSIxMDAlIi8+PC9saW5lYXJHcmFkaWVudD48bGluZWFyR3JhZGllbnQgeDE9IjcxLjY0JSIgeTE9IjEwLjg5JSIgeDI9IjcxLjY0JSIgeTI9Ijg5Ljc4JSIgaWQ9ImIiPjxzdG9wIHN0b3AtY29sb3I9IiNGN0Y3RjciIG9mZnNldD0iMCUiLz48c3RvcCBzdG9wLWNvbG9yPSIjRjdGN0Y3IiBvZmZzZXQ9IjEwMCUiLz48L2xpbmVhckdyYWRpZW50PjwvZGVmcz48ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiIG9wYWNpdHk9Ii4yIj48cGF0aCBmaWxsPSJ1cmwoI2EpIiBkPSJNMCAwaDE0NDB2NzIwSDB6Ii8+PHBhdGggZD0iTTAgMGgxNDQwdjcyMEgweiIgZmlsbD0idXJsKCNiKSIvPjxwYXRoIGQ9Ik0zNjAgMzYwYzE5OC44MiAwIDM2MCAxNjEuMTggMzYwIDM2MHMtMTYxLjE4IDM2MC0zNjAgMzYwUzAgNTU4LjgyIDAgMzYwIDE2MS4xOCAwIDM2MCAweiIgZmlsbD0iI0U1NjQ0MSIgb3BhY2l0eT0iLjEiLz48cGF0aCBkPSJNMTA4MCAzNjBjMTk4LjgyIDAgMzYwIDE2MS4xOCAzNjAgMzYwcy0xNjEuMTggMzYwLTM2MCAzNjAtMzYwLTE2MS4xOC0zNjAtMzYwIDE2MS4xOC0zNjAgMzYwLTM2MHoiIGZpbGw9IiNFNTY0NDEiIG9wYWNpdHk9Ii4wNSIvPjwvZz48L3N2Zz4=');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .login-container {
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            background-color: rgba(255, 255, 255, 0.95);
        }

        .form-input-focus:focus {
            box-shadow: 0 0 0 3px rgba(229, 100, 65, 0.2);
        }

        .login-btn {
            background-color: #E56441;
            transition: all 0.3s ease;
        }

            .login-btn:hover {
                background-color: #D25638;
                transform: translateY(-2px);
            }

        .icon-pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
            }

            50% {
                transform: scale(1.1);
            }

            100% {
                transform: scale(1);
            }
        }
    </style>
</head>
<body class="bg-background min-h-screen flex items-center justify-center p-4">
    <form id="form1" runat="server" class="w-full max-w-lg">
        <div class="login-container p-10 rounded-2xl">
            <div class="text-center mb-8">
                <div class="flex items-center justify-center mb-4">
                    <div class="h-16 w-16 rounded-full bg-primary/10 flex items-center justify-center icon-pulse">
                        <i class="fas fa-utensils text-primary text-4xl"></i>
                    </div>
                </div>
                <h1 class="text-4xl font-bold text-gray-800 mb-1 font-poppins">PARES POS</h1>
                <p class="text-gray-500 text-lg">Sign in to your account</p>
            </div>

            <div class="space-y-6 mb-8">
                <div>
                    <label for="username" class="block text-base font-medium text-gray-700 mb-1">Username</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                            <i class="fas fa-user text-gray-400"></i>
                        </div>
                        <asp:TextBox ID="txtUsername" runat="server" placeholder="Enter your username"
                            CssClass="block w-full pl-12 pr-4 py-4 text-lg rounded-xl border border-gray-300 form-input-focus focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary" />
                    </div>
                </div>

                <div>
                    <label for="username" class="block text-base font-medium text-gray-700 mb-1">Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-400"></i>
                        </div>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password"
                            CssClass="block w-full pl-12 pr-4 py-4 text-lg rounded-xl border border-gray-300 form-input-focus focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary" />
                    </div>
                </div>


            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Sign in" OnClick="btnLogin_Click"
                CssClass="login-btn w-full cursor-pointer flex justify-center py-4 px-4 border border-transparent rounded-xl shadow-md text-lg font-medium text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary" />

            <asp:Label ID="lblErrorMessage" runat="server" CssClass="mt-4 block text-center text-danger text-base" Visible="false"></asp:Label>

            
        </div>

        <div class="mt-8 text-center text-gray-500 text-sm">
            &copy; 2025 PARES POS System. All rights reserved.
        </div>
    </form>
</body>
</html>
