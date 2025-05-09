<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="PARESPOS.Pages.User.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Pares POS - Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Tailwind CSS -->
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet" />
    <style>
        /* Custom styles that will complement Tailwind */
        body {
            font-family: 'Poppins', sans-serif; /* Changed from Inter to Poppins */
        }

        /* Hide scrollbar for Chrome, Safari and Opera */
        .no-scrollbar::-webkit-scrollbar {
            display: none;
        }

        /* Hide scrollbar for IE, Edge and Firefox */
        .no-scrollbar {
            -ms-overflow-style: none; /* IE and Edge */
            scrollbar-width: none; /* Firefox */
        }

        /* Custom color classes */
        .bg-primary {
            background-color: #E56441;
        }

        .bg-secondary {
            background-color: #3E5E77;
        }

        .bg-light {
            background-color: #f7f7f7;
        }

        .bg-neutral {
            background-color: #A8A8AC;
        }

        .text-primary {
            color: #E56441;
        }

        .text-secondary {
            color: #3E5E77;
        }

        .border-primary {
            border-color: #E56441;
        }

        .border-secondary {
            border-color: #3E5E77;
        }

        .hover\:bg-primary-dark:hover {
            background-color: #D45435;
        }

        .hover\:bg-secondary-dark:hover {
            background-color: #344E63;
        }

        .focus\:ring-primary:focus {
            --tw-ring-color: #E56441;
        }

        .focus\:ring-secondary:focus {
            --tw-ring-color: #3E5E77;
        }
    </style>
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <div class="flex h-screen">
            <!-- Left Sidebar for Categories Navigation -->
            <div class="w-64 bg-white shadow-md h-full fixed left-0 top-0 overflow-y-auto no-scrollbar">
                <div class="p-4 border-b border-gray-200">
                    <h1 class="text-2xl font-bold text-primary">Pares POS</h1>
                </div>
                <div class="p-4">
                    <h2 class="text-lg font-semibold mb-3 text-secondary">Categories</h2>
                    <asp:Repeater ID="rptCategories" runat="server">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnCategory" runat="server"
                                CommandArgument='<%# Eval("CategoryID") %>'
                                OnClick="btnCategory_Click"
                                CssClass="block w-full text-left py-2 px-3 mb-1 rounded hover:bg-primary hover:text-white transition-colors duration-200">
                                <%# Eval("CategoryName") %>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Main Content Area -->
            <div class="ml-64 mr-80 flex-1 flex flex-col h-screen">
                <!-- Search Bar -->
                <div class="p-4 bg-white shadow-sm">
                    <div class="flex">
                        <asp:TextBox ID="txtSearch" runat="server"
                            CssClass="flex-1 py-2 px-4 border border-gray-300 rounded-l focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                            placeholder="Search products..."></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                            CssClass="bg-primary text-white py-2 px-4 rounded-r hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary focus:ring-opacity-50" />
                    </div>
                </div>

                <!-- Products Grid -->
                <div class="flex-1 p-4 overflow-y-auto">
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                        <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                            <ItemTemplate>
                                <div class="bg-white rounded-lg shadow-md overflow-hidden relative">
                                    <!-- SKU at the top -->
                                    <div class="absolute top-2 left-2 bg-secondary text-white text-xs px-2 py-1 rounded-full">
                                        SKU: <%# Eval("ProductID") %>
                                    </div>

                                    <!-- Stock Status -->
                                    <div class='<%# GetStockStatusClass(Eval("StockStatus").ToString()) %>'>
                                        <%# Eval("StockStatus") %>
                                    </div>

                                    <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("ProductName") %>' class="w-full h-48 object-cover" />

                                    <div class="p-4">
                                        <h3 class="text-lg font-semibold text-secondary"><%# Eval("ProductName") %></h3>
                                        <p class="text-gray-500 text-sm"><%# Eval("CategoryName") %></p>
                                        <div class="flex justify-between items-center mt-3">
                                            <span class="text-xl font-bold text-primary">₱<%# Eval("Price", "{0:0.00}") %></span>
                                            <asp:LinkButton ID="btnAddToCart" runat="server"
                                                CommandName="AddToCart"
                                                CommandArgument='<%# Eval("ProductID") %>'
                                                CssClass='<%# Convert.ToBoolean(Eval("InStock")) ? "bg-primary text-white py-1 px-3 rounded hover:bg-primary-dark" : "bg-neutral text-white py-1 px-3 rounded cursor-not-allowed" %>'
                                                Enabled='<%# Convert.ToBoolean(Eval("InStock")) %>'>
                                                <i class="fas fa-plus mr-1"></i> Add
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>

            <!-- Right Sidebar (Checkout) -->
            <div class="w-80 bg-white shadow-md h-full fixed right-0 top-0 flex flex-col">
                <div class="p-4 border-b border-gray-200">
                    <h2 class="text-xl font-bold text-secondary">Order Summary</h2>
                    <p class="text-sm text-gray-500">Order #<asp:Label ID="lblOrderNumber" runat="server" CssClass="font-semibold"></asp:Label></p>
                </div>

                <!-- Order Items -->
                <div class="p-4 overflow-y-auto flex-grow">
                    <asp:Repeater ID="rptOrderItems" runat="server" OnItemCommand="rptOrderItems_ItemCommand">
                        <ItemTemplate>
                            <div class="flex justify-between items-center py-2 border-b border-gray-200">
                                <div class="flex-1">
                                    <h4 class="font-medium"><%# Eval("ProductName") %></h4>
                                    <div class="flex items-center text-sm text-gray-500">
                                        <span>₱<%# Eval("Price", "{0:0.00}") %> x <%# Eval("Quantity") %></span>
                                    </div>
                                </div>
                                <div class="flex items-center">
                                    <span class="font-semibold mr-2">₱<%# Eval("Subtotal", "{0:0.00}") %></span>
                                    <asp:LinkButton ID="btnRemoveItem" runat="server"
                                        CommandName="RemoveItem"
                                        CommandArgument='<%# Eval("ProductID") %>'
                                        CssClass="text-primary hover:text-primary-dark">
                                        <i class="fas fa-minus-circle"></i>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Order Calculations and Checkout (Sticky) -->
                <div class="mt-auto">
                    <!-- Order Calculations -->
                    <div class="p-4 bg-light">
                        <div class="flex justify-between mb-2">
                            <span>Subtotal:</span>
                            <span>₱<asp:Label ID="lblSubtotal" runat="server">0.00</asp:Label></span>
                        </div>
                        <div class="flex justify-between mb-2">
                            <span>Tax (<asp:Label ID="lblTaxRate" runat="server">12</asp:Label>%):</span>
                            <span>₱<asp:Label ID="lblTax" runat="server">0.00</asp:Label></span>
                        </div>
                        <div class="flex justify-between font-bold text-lg">
                            <span>Total:</span>
                            <span>₱<asp:Label ID="lblTotal" runat="server">0.00</asp:Label></span>
                        </div>
                    </div>

                    <!-- Checkout Buttons -->
                    <div class="p-4 flex space-x-2 border-t border-gray-200">
                        <asp:Button ID="btnClearOrder" runat="server" Text="Clear" OnClick="btnClearOrder_Click"
                            CssClass="flex-1 bg-neutral text-white py-2 px-4 rounded hover:bg-gray-500 focus:outline-none cursor-pointer" />
                        <asp:Button ID="btnCheckout" runat="server" Text="Checkout" OnClick="btnCheckout_Click"
                            CssClass="flex-1 bg-primary text-white py-2 px-4 rounded hover:bg-primary-dark cursor-pointer focus:outline-none" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Checkout Modal -->
        <div id="checkoutModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
            <div class="bg-white rounded-lg shadow-lg max-w-lg w-full mx-4">
                <div class="p-6">
                    <h3 class="text-2xl font-bold mb-4 text-secondary">Complete Order</h3>

                    <div class="mb-6">
                        <p class="text-xl font-bold">Total: ₱<asp:Label ID="lblModalTotal" runat="server"></asp:Label></p>
                    </div>

                    <div class="mb-4">
                        <h4 class="text-lg font-semibold mb-2">Select Payment Method</h4>
                        <div class="flex space-x-2">
                            <asp:Button ID="btnCashPayment" runat="server" Text="Cash" OnClick="btnCashPayment_Click"
                                CssClass="flex-1 bg-secondary text-white py-2 px-4 rounded hover:bg-secondary-dark focus:outline-none" />
                            <asp:Button ID="btnCardPayment" runat="server" Text="Card" OnClick="btnCardPayment_Click"
                                CssClass="flex-1 bg-primary text-white py-2 px-4 rounded hover:bg-primary-dark focus:outline-none" />
                        </div>
                    </div>

                    <asp:Panel ID="pnlCashPayment" runat="server" CssClass="mb-4">
                        <h4 class="text-lg font-semibold mb-2">Cash Amount</h4>
                        <div class="flex space-x-2 mb-3">
                            <asp:Button ID="btn100" runat="server" Text="₱100" CommandArgument="100" OnClick="btnQuickAmount_Click"
                                CssClass="flex-1 bg-light text-gray-700 py-1 px-2 rounded hover:bg-gray-300 focus:outline-none" />
                            <asp:Button ID="btn200" runat="server" Text="₱200" CommandArgument="200" OnClick="btnQuickAmount_Click"
                                CssClass="flex-1 bg-light text-gray-700 py-1 px-2 rounded hover:bg-gray-300 focus:outline-none" />
                            <asp:Button ID="btn500" runat="server" Text="₱500" CommandArgument="500" OnClick="btnQuickAmount_Click"
                                CssClass="flex-1 bg-light text-gray-700 py-1 px-2 rounded hover:bg-gray-300 focus:outline-none" />
                            <asp:Button ID="btn1000" runat="server" Text="₱1000" CommandArgument="1000" OnClick="btnQuickAmount_Click"
                                CssClass="flex-1 bg-light text-gray-700 py-1 px-2 rounded hover:bg-gray-300 focus:outline-none" />
                        </div>
                        <div class="flex items-center">
                            <label class="w-24">Amount:</label>
                            <asp:TextBox ID="txtCashAmount" runat="server" CssClass="flex-1 py-2 px-4 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-secondary"></asp:TextBox>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlChange" runat="server" CssClass="mb-6">
                        <div class="flex justify-between mb-2">
                            <span>Cash Amount:</span>
                            <span>₱<asp:Label ID="lblCashAmount" runat="server">0.00</asp:Label></span>
                        </div>
                        <div class="flex justify-between font-bold">
                            <span>Change:</span>
                            <span>₱<asp:Label ID="lblChange" runat="server">0.00</asp:Label></span>
                        </div>
                    </asp:Panel>

                    <div class="flex justify-end space-x-2">
                        <asp:Button ID="btnCancelCheckout" runat="server" Text="Cancel" OnClick="btnCancelCheckout_Click"
                            CssClass="bg-neutral text-white py-2 px-4 rounded hover:bg-gray-500 focus:outline-none" />
                        <asp:Button ID="btnCompletePayment" runat="server" Text="Complete Payment" OnClick="btnCompletePayment_Click"
                            CssClass="bg-secondary text-white py-2 px-4 rounded hover:bg-secondary-dark focus:outline-none" />
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- JavaScript -->
    <script type="text/javascript">
        function showCheckoutModal() {
            document.getElementById('checkoutModal').classList.remove('hidden');
        }

        function hideCheckoutModal() {
            document.getElementById('checkoutModal').classList.add('hidden');
        }
    </script>
</body>
</html>
