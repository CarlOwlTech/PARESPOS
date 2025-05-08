<%@ Page Title="POS Dashboard" Language="C#" MasterPageFile="~/MasterPages/Site.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="PARESPOS.Pages.User.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    POS Dashboard
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Additional head content for user dashboard -->
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SidebarContent" runat="server">
    <!-- No sidebar for cashier view -->
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="flex-1 flex overflow-hidden min-h-[calc(100vh-56px)]">
        <!-- Left Side: Products -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- Categories Navigation -->
            <div class="bg-white p-4 border-b">
                <div class="flex space-x-2 overflow-x-auto pb-2">
                    <asp:LinkButton ID="btnAllItems" runat="server" OnClick="btnCategory_Click" CommandArgument="All"
                        CssClass="px-4 py-2 bg-primary text-white rounded-md whitespace-nowrap">All Items</asp:LinkButton>
                    
                    <asp:Repeater ID="rptCategories" runat="server">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnCategory" runat="server" OnClick="btnCategory_Click" 
                                CommandArgument='<%# Eval("CategoryID") %>'
                                CssClass="px-4 py-2 bg-gray-100 text-gray-700 rounded-md whitespace-nowrap hover:bg-gray-200">
                                <%# Eval("CategoryName") %>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Search Bar -->
            <div class="bg-white p-4 border-b">
                <div class="flex">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search products..." 
                        CssClass="flex-1 px-4 py-2 border border-gray-300 rounded-l-md focus:outline-none focus:ring-primary focus:border-primary"></asp:TextBox>
                    <asp:LinkButton ID="btnSearch" runat="server" OnClick="btnSearch_Click"
                        CssClass="bg-primary text-white px-4 py-2 rounded-r-md">
                        <i class="fas fa-search"></i>
                    </asp:LinkButton>
                </div>
            </div>

            <!-- Products Grid -->
            <div class="flex-1 overflow-y-auto p-4 bg-gray-50 min-h-[calc(100vh-300px)]">
                <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                    <HeaderTemplate>
                        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="bg-white rounded-lg shadow-sm overflow-hidden cursor-pointer hover:shadow-md transition">
                            <div class="h-40 bg-gray-200 relative">
                                <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("ProductName") %>' class="w-full h-full object-cover">
                                <span class='<%# GetStockStatusClass(Eval("StockStatus").ToString()) %>'>
                                    <%# Eval("StockStatus") %>
                                </span>
                            </div>
                            <div class="p-4">
                                <h3 class="font-medium text-gray-800"><%# Eval("ProductName") %></h3>
                                <p class="text-gray-500 text-sm"><%# Eval("CategoryName") %></p>
                                <div class="mt-2 flex justify-between items-center">
                                    <span class="font-bold text-primary"><%# Eval("Price", "${0:F2}") %></span>
                                    <asp:LinkButton ID="btnAddToCart" runat="server" CommandName="AddToCart" CommandArgument='<%# Eval("ProductID") %>'
                                        CssClass='<%# Convert.ToBoolean(Eval("InStock")) ? "text-primary hover:text-primary/80" : "text-gray-400 cursor-not-allowed" %>'
                                        Enabled='<%# Convert.ToBoolean(Eval("InStock")) %>'>
                                        <i class="fas fa-plus-circle text-lg"></i>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>

        <!-- Right Side: Order -->
        <div class="w-96 bg-white border-l border-gray-200 flex flex-col">
            <!-- Order Header -->
            <div class="p-4 border-b">
                <h2 class="text-lg font-medium text-gray-800">Current Order</h2>
                <p class="text-sm text-gray-500">Order #<asp:Label ID="lblOrderNumber" runat="server"></asp:Label></p>
            </div>

            <!-- Order Items -->
            <div class="flex-1 overflow-y-auto p-4 space-y-4">
                <asp:Repeater ID="rptOrderItems" runat="server" OnItemCommand="rptOrderItems_ItemCommand">
                    <ItemTemplate>
                        <div class="flex justify-between items-center">
                            <div class="flex-1">
                                <div class="flex items-center">
                                    <div class="w-10 h-10 bg-gray-200 rounded-md flex items-center justify-center">
                                        <span class="text-xs font-medium"><%# Eval("Quantity") %>x</span>
                                    </div>
                                    <div class="ml-3">
                                        <h3 class="text-sm font-medium text-gray-800"><%# Eval("ProductName") %></h3>
                                        <p class="text-xs text-gray-500"><%# Eval("Price", "${0:F2}") %> each</p>
                                    </div>
                                </div>
                            </div>
                            <div class="text-right">
                                <span class="text-sm font-medium"><%# Eval("Subtotal", "${0:F2}") %></span>
                                <asp:LinkButton ID="btnRemoveItem" runat="server" CommandName="RemoveItem" CommandArgument='<%# Eval("ProductID") %>'
                                    CssClass="ml-2 text-gray-400 hover:text-danger">
                                    <i class="fas fa-times-circle"></i>
                                </asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <!-- Order Summary -->
            <div class="p-4 border-t bg-gray-50">
                <div class="space-y-2">
                    <div class="flex justify-between">
                        <span class="text-gray-600">Subtotal</span>
                        <span class="font-medium">$<asp:Label ID="lblSubtotal" runat="server">0.00</asp:Label></span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-gray-600">Tax (<asp:Label ID="lblTaxRate" runat="server">12</asp:Label>%)</span>
                        <span class="font-medium">$<asp:Label ID="lblTax" runat="server">0.00</asp:Label></span>
                    </div>
                    <div class="flex justify-between text-lg font-bold">
                        <span>Total</span>
                        <span class="text-primary">$<asp:Label ID="lblTotal" runat="server">0.00</asp:Label></span>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="p-4 border-t">
                <div class="grid grid-cols-2 gap-4">
                    <asp:LinkButton ID="btnClearOrder" runat="server" OnClick="btnClearOrder_Click"
                        CssClass="py-2 px-4 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 text-center">
                        Clear Order
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnCheckout" runat="server" OnClick="btnCheckout_Click"
                        CssClass="py-2 px-4 bg-primary text-white rounded-md hover:bg-primary/90 text-center">
                        Checkout
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

    <!-- Checkout Modal -->
    <asp:Panel ID="pnlCheckoutModal" runat="server" CssClass="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-lg shadow-lg w-full max-w-lg">
            <div class="p-6">
                <h2 class="text-xl font-bold text-gray-800 mb-4">Checkout</h2>
                
                <!-- Payment Methods -->
                <div class="mb-6">
                    <h3 class="text-sm font-medium text-gray-700 mb-2">Payment Method</h3>
                    <div class="grid grid-cols-2 gap-4">
                        <asp:LinkButton ID="btnCashPayment" runat="server" OnClick="btnCashPayment_Click"
                            CssClass="py-3 px-4 bg-white border-2 border-primary text-primary rounded-md hover:bg-primary/5 flex items-center justify-center">
                            <i class="fas fa-money-bill-wave mr-2"></i>
                            <span>Cash</span>
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnCardPayment" runat="server" OnClick="btnCardPayment_Click"
                            CssClass="py-3 px-4 bg-white border border-gray-300 text-gray-700 rounded-md hover:bg-gray-50 flex items-center justify-center">
                            <i class="fas fa-credit-card mr-2"></i>
                            <span>Card</span>
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Cash Amount -->
                <asp:Panel ID="pnlCashPayment" runat="server" CssClass="mb-6">
                    <label for="txtCashAmount" class="block text-sm font-medium text-gray-700 mb-2">Cash Amount</label>
                    <asp:TextBox ID="txtCashAmount" runat="server" TextMode="Number" Step="0.01" 
                        CssClass="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary"></asp:TextBox>
                    
                    <div class="mt-2 grid grid-cols-3 gap-2">
                        <asp:Button ID="btn25" runat="server" Text="$25" OnClick="btnQuickAmount_Click" CommandArgument="25"
                            CssClass="py-2 px-4 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 text-center" />
                        <asp:Button ID="btn50" runat="server" Text="$50" OnClick="btnQuickAmount_Click" CommandArgument="50"
                            CssClass="py-2 px-4 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 text-center" />
                        <asp:Button ID="btn100" runat="server" Text="$100" OnClick="btnQuickAmount_Click" CommandArgument="100"
                            CssClass="py-2 px-4 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 text-center" />
                    </div>
                </asp:Panel>

                <!-- Change -->
                <asp:Panel ID="pnlChange" runat="server" CssClass="mb-6 p-4 bg-gray-50 rounded-md">
                    <div class="flex justify-between">
                        <span class="text-gray-600">Total</span>
                        <span class="font-medium">$<asp:Label ID="lblModalTotal" runat="server">0.00</asp:Label></span>
                    </div>
                    <div class="flex justify-between mt-2">
                        <span class="text-gray-600">Cash</span>
                        <span class="font-medium">$<asp:Label ID="lblCashAmount" runat="server">0.00</asp:Label></span>
                    </div>
                    <div class="flex justify-between mt-2 text-lg font-bold">
                        <span>Change</span>
                        <span class="text-success">$<asp:Label ID="lblChange" runat="server">0.00</asp:Label></span>
                    </div>
                </asp:Panel>

                <!-- Actions -->
                <div class="flex justify-end space-x-4">
                    <asp:Button ID="btnCancelCheckout" runat="server" Text="Cancel" OnClick="btnCancelCheckout_Click"
                        CssClass="py-2 px-4 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200" />
                    <asp:Button ID="btnCompletePayment" runat="server" Text="Complete Payment" OnClick="btnCompletePayment_Click"
                        CssClass="py-2 px-4 bg-primary text-white rounded-md hover:bg-primary/90" />
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript">
        function showCheckoutModal() {
            document.getElementById('<%= pnlCheckoutModal.ClientID %>').classList.remove('hidden');
        }

        function hideCheckoutModal() {
            document.getElementById('<%= pnlCheckoutModal.ClientID %>').classList.add('hidden');
        }

        // Calculate change when cash amount changes
        function calculateChange() {
            var total = parseFloat(document.getElementById('<%= lblModalTotal.ClientID %>').innerText);
            var cash = parseFloat(document.getElementById('<%= txtCashAmount.ClientID %>').value) || 0;
            var change = cash - total;
            
            if (change >= 0) {
                document.getElementById('<%= lblCashAmount.ClientID %>').innerText = cash.toFixed(2);
                document.getElementById('<%= lblChange.ClientID %>').innerText = change.toFixed(2);
            } else {
                document.getElementById('<%= lblCashAmount.ClientID %>').innerText = cash.toFixed(2);
                document.getElementById('<%= lblChange.ClientID %>').innerText = "0.00";
            }
        }

        // Attach event listeners
        document.addEventListener('DOMContentLoaded', function() {
            var cashInput = document.getElementById('<%= txtCashAmount.ClientID %>');
            if (cashInput) {
                cashInput.addEventListener('input', calculateChange);
            }
        });
    </script>
</asp:Content>