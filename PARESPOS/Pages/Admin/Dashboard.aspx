<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="PARESPOS.Pages.Admin.Dashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <!-- Tailwind CDN -->
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #E56441;
            --background: #f7f7f7;
            --secondary: #A8A8AC;
        }

        body {
            font-family: 'Poppins', sans-serif; /* Changed from Inter to Poppins */
            background-color: var(--background);
        }

        .font-poppins {
            font-family: 'Poppins', sans-serif;
        }

        .primary-bg {
            background-color: var(--primary);
        }

        .primary-text {
            color: var(--primary);
        }

        .secondary-bg {
            background-color: var(--secondary);
        }

        .secondary-text {
            color: var(--secondary);
        }

        .custom-shadow {
            box-shadow: 0 4px 12px rgba(168, 168, 172, 0.2);
        }

        .nav-item {
            flex-direction: column;
            padding: 1.25rem 0.75rem;
            border-radius: 0.75rem;
            text-align: center;
            width: 100%;
        }

            .nav-item i {
                font-size: 1.5rem;
                margin-bottom: 0.5rem;
            }

            .nav-item.active {
                background-color: var(--primary);
            }

        .card-hover:hover {
            transform: translateY(-3px);
            transition: all 0.3s ease;
        }

        /* Apply Poppins to specific elements */
        h1, h2, h3, h4, h5, h6, p, a, span, div, table, input, button, select, textarea {
            font-family: 'Poppins', sans-serif;
        }

        /* Apply Poppins to GridView elements */
        .min-w-full * {
            font-family: 'Poppins', sans-serif;
        }
    </style>
    <!-- Disable React DevTools message -->
    <script>
        window.__REACT_DEVTOOLS_GLOBAL_HOOK__ = { isDisabled: true };
    </script>
</head>
<body class="bg-[#f7f7f7] font-poppins">
    <form id="form1" runat="server">

        <!-- Header -->
        <header class="bg-white fixed top-0 left-0 right-0 z-10 custom-shadow h-20">
            <div class="px-6 flex justify-center items-center h-full">
                <h2 class="text-4xl font-bold primary-text font-poppins text-center pl-8 mr-10">ADMIN</h2>
                <div class="relative w-full">
                    <i class="fas fa-search absolute left-5 top-5 text-[#A8A8AC] text-2xl"></i>
                    <asp:TextBox
                        ID="txtSearch"
                        runat="server"
                        placeholder="Search products..."
                        CssClass="w-full pl-14 pr-6 py-4 bg-[#f7f7f7] border border-[#E56441] rounded-full focus:outline-none focus:ring-2 focus:ring-[#E56441] text-lg font-poppins">
                    </asp:TextBox>
                </div>
            </div>
        </header>


        <!-- Sidebar -->
        <aside class="bg-white text-gray-800 w-56 min-h-screen fixed top-0 left-0 pt-24 custom-shadow transform transition-transform duration-300 ease-in-out z-0 md:translate-x-0 -translate-x-full" id="sidebar">
            <div class="p-4 h-full flex flex-col">
                <div class="mb-8 text-center">
                    <h2 class="text-2xl font-bold primary-text font-poppins">PARES POS</h2>
                </div>

                <nav class="space-y-4 flex-grow">
                    <a href="Dashboard.aspx" class="flex nav-item active text-white font-poppins">
                        <i class="fas fa-th-large"></i>
                        <span class="text-lg font-medium">Dashboard</span>
                    </a>
                    <a href="Products.aspx" class="flex nav-item hover:bg-gray-100 text-gray-700 transition-all font-poppins">
                        <i class="fas fa-box"></i>
                        <span class="text-lg">Products</span>
                    </a>
                    <a href="SalesReport.aspx" class="flex nav-item hover:bg-gray-100 text-gray-700 transition-all font-poppins">
                        <i class="fas fa-chart-bar"></i>
                        <span class="text-lg">Sales Report</span>
                    </a>
                    <a href="ManageAccounts.aspx" class="flex nav-item hover:bg-gray-100 text-gray-700 transition-all font-poppins">
                        <i class="fas fa-users"></i>
                        <span class="text-lg">Manage Accounts</span>
                    </a>
                </nav>

                <div class="mt-auto border-t border-gray-200 pt-6">
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click"
                        CssClass="flex nav-item hover:bg-red-100 text-gray-700 hover:text-red-600 transition-all font-poppins">
                        <i class="fas fa-sign-out-alt"></i>
                        <span class="text-lg">Logout</span>
                    </asp:LinkButton>
                </div>
            </div>
        </aside>

        <!-- Mobile sidebar toggle -->
        <button type="button" class="md:hidden fixed bottom-6 right-6 z-20 h-16 w-16 rounded-full primary-bg text-white shadow-lg flex items-center justify-center font-poppins" id="mobileSidebarToggle">
            <i class="fas fa-bars text-2xl"></i>
        </button>

        <!-- Main Content -->
        <main class="md:ml-64 pt-28 px-6 pb-8 font-poppins">
            <div class="max-w-full">
                <div class="flex justify-between items-center mb-8">
                    <h1 class="text-3xl font-bold text-gray-800 font-poppins">Products Dashboard</h1>
                    <div class="flex">
                    </div>
                </div>

                <!-- Dashboard Summary -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div class="bg-white rounded-xl custom-shadow p-8 card-hover">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-xl font-medium text-gray-700 font-poppins">Total Products</h2>
                            <div class="h-14 w-14 rounded-full bg-[#E56441] bg-opacity-20 flex items-center justify-center">
                                <i class="fas fa-box text-2xl primary-text"></i>
                            </div>
                        </div>
                        <p class="text-4xl font-bold text-gray-800 font-poppins">
                            <asp:Literal ID="litTotalProducts" runat="server" />
                        </p>
                        <p class="text-lg text-[#A8A8AC] mt-3 font-poppins">Products in inventory</p>
                    </div>
                    <div class="bg-white rounded-xl custom-shadow p-8 card-hover">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-xl font-medium text-gray-700 font-poppins">Low Stock</h2>
                            <div class="h-14 w-14 rounded-full bg-yellow-100 flex items-center justify-center">
                                <i class="fas fa-exclamation-circle text-2xl text-yellow-500"></i>
                            </div>
                        </div>
                        <p class="text-4xl font-bold text-gray-800 font-poppins">
                            <asp:Literal ID="litLowStock" runat="server" />
                        </p>
                        <p class="text-lg text-[#A8A8AC] mt-3 font-poppins">Products running low</p>
                    </div>
                    <div class="bg-white rounded-xl custom-shadow p-8 card-hover">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-xl font-medium text-gray-700 font-poppins">Out of Stock</h2>
                            <div class="h-14 w-14 rounded-full bg-red-100 flex items-center justify-center">
                                <i class="fas fa-times-circle text-2xl text-red-500"></i>
                            </div>
                        </div>
                        <p class="text-4xl font-bold text-gray-800 font-poppins">
                            <asp:Literal ID="litOutOfStock" runat="server" />
                        </p>
                        <p class="text-lg text-[#A8A8AC] mt-3 font-poppins">Products out of stock</p>
                    </div>
                    <div class="bg-white rounded-xl custom-shadow p-8 card-hover">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-xl font-medium text-gray-700 font-poppins">Most Sold</h2>
                            <div class="h-14 w-14 rounded-full bg-green-100 flex items-center justify-center">
                                <i class="fas fa-award text-2xl text-green-500"></i>
                            </div>
                        </div>
                        <p class="text-xl font-medium text-gray-800 font-poppins">
                            <asp:Literal ID="litMostSold" runat="server" />
                        </p>
                        <p class="text-lg text-[#A8A8AC] mt-3 font-poppins">Best performing product</p>
                    </div>
                </div>


                <!-- Product Inventory Table -->
                <div class="bg-white rounded-xl custom-shadow overflow-hidden">
                    <div class="px-8 py-6 border-b border-gray-200">
                        <h2 class="text-2xl font-medium text-gray-800 font-poppins">Recent Product Listed</h2>
                    </div>

                    <div class="overflow-x-auto">
                        <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="false"
                            CssClass="min-w-full divide-y divide-gray-200 font-poppins"
                            HeaderStyle-CssClass="bg-gray-50 px-8 py-4 text-left text-base font-medium text-gray-500 uppercase tracking-wider font-poppins"
                            RowStyle-CssClass="bg-white hover:bg-gray-50 font-poppins"
                            AlternatingRowStyle-CssClass="bg-gray-50 hover:bg-gray-100 font-poppins"
                            AllowPaging="true" PageSize="8" OnPageIndexChanging="gvProducts_PageIndexChanging"
                            OnRowCommand="gvProducts_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="SKU" HeaderText="SKU" HeaderStyle-CssClass="text-center py-5" ItemStyle-CssClass="px-8 py-5 text-center whitespace-nowrap text-base text-gray-900 font-poppins" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" HeaderStyle-CssClass="text-center py-5" ItemStyle-CssClass="px-8 py-5 text-center whitespace-nowrap text-base text-gray-900 font-poppins" />
                                <asp:BoundField DataField="Description" HeaderText="Description" HeaderStyle-CssClass="text-center py-5" ItemStyle-CssClass="px-8 py-5 pl-20 whitespace-nowrap text-base text-gray-500 max-w-xs truncate font-poppins" />
                                <asp:BoundField DataField="Category" HeaderText="Category" HeaderStyle-CssClass="text-center py-5" ItemStyle-CssClass="px-8 py-5 text-center  whitespace-nowrap text-base text-gray-500 font-poppins" />
                                <asp:TemplateField HeaderText="Stock Level" HeaderStyle-CssClass="text-center py-5" ItemStyle-CssClass="px-8 py-5 text-center whitespace-nowrap text-base font-poppins">
                                    <ItemTemplate>
                                        <div class="flex items-center">
                                            <%# GetStockLevelBadge(Eval("StockLevel").ToString()) %>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Price" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="px-8 py-5 text-center whitespace-nowrap text-base text-gray-900 font-poppins">
                                    <ItemTemplate>
                                        ₱<%# Eval("Price", "{0:N2}") %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                            <PagerStyle CssClass="bg-white border-t border-gray-200 px-8 py-4 flex items-center justify-between font-poppins" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </main>
    </form>

    <script>
        // Mobile sidebar toggle
        document.getElementById('mobileSidebarToggle').addEventListener('click', function () {
            const sidebar = document.getElementById('sidebar');
            sidebar.classList.toggle('-translate-x-full');
        });

        // Close sidebar when clicking outside on mobile
        document.addEventListener('click', function (event) {
            const sidebar = document.getElementById('sidebar');
            const toggleButton = document.getElementById('mobileSidebarToggle');

            if (window.innerWidth < 768 &&
                !sidebar.contains(event.target) &&
                !toggleButton.contains(event.target) &&
                !sidebar.classList.contains('-translate-x-full')) {
                sidebar.classList.add('-translate-x-full');
            }
        });
    </script>

    <script runat="server">
        protected string GetStockLevelBadge(string stockLevel)
        {
            int stock;
            if (int.TryParse(stockLevel, out stock))
            {
                if (stock <= 0)
                {
                    return "<span class='px-3 py-1 text-base font-semibold rounded-full bg-red-100 text-red-800 font-poppins'>" + stockLevel + "</span>";
                }
                else if (stock <= 10)
                {
                    return "<span class='px-3 py-1 text-base font-semibold rounded-full bg-yellow-100 text-yellow-800 font-poppins'>" + stockLevel + "</span>";
                }
                else
                {
                    return "<span class='px-3 py-1 text-base font-semibold rounded-full bg-green-100 text-green-800 font-poppins'>" + stockLevel + "</span>";
                }
            }
            return "<span class='px-3 py-1 text-base font-semibold rounded-full bg-gray-100 text-gray-800 font-poppins'>" + stockLevel + "</span>";
        }
    </script>
</body>
</html>
