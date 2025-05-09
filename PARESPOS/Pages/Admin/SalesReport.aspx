<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SalesReport.aspx.cs" Inherits="PARESPOS.Pages.Admin.SalesReport" %>


<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Report</title>

    <!-- External Styles & Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

    <!-- Custom Styles -->
    <style>
        :root {
            --primary: #E56441;
            --background: #f7f7f7;
            --secondary: #A8A8AC;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--background);
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
            display: flex;
            flex-direction: column;
            padding: 1.25rem 0.75rem;
            border-radius: 0.75rem;
            text-align: center;
            width: 100%;
            font-family: 'Poppins', sans-serif;
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

        /* Analytics Card Styles */
        .analytics-card {
            background-color: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(168, 168, 172, 0.2);
            transition: all 0.3s ease;
        }

        .analytics-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(168, 168, 172, 0.3);
        }

        .analytics-value {
            font-size: 2.5rem;
            font-weight: 600;
            margin: 16px 0;
        }

        .analytics-label {
            font-size: 1rem;
            color: var(--secondary);
            margin-bottom: 8px;
        }

        .trend-up {
            color: #22c55e;
        }

        .trend-down {
            color: #ef4444;
        }

        /* Chart Container */
        .chart-container {
            background-color: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(168, 168, 172, 0.2);
            margin-top: 24px;
            height: 300px;
        }

        /* Tabs */
        .report-tab {
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .report-tab.active {
            background-color: var(--primary);
            color: white;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .hidden {
            display: none !important;
        }

        /* Date Range Selector */
        .date-selector {
            padding: 10px 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            margin-right: 12px;
        }

        /* Print Button */
        .print-button {
            background-color: var(--primary);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .print-button:hover {
            background-color: #d25638;
        }
    </style>
</head>

<body class="bg-[#f7f7f7] font-poppins">
    <form id="form1" runat="server">

        <!-- Header -->
        <header class="fixed top-0 left-0 right-0 bg-white custom-shadow h-20 z-10">
            <div class="flex items-center h-full px-6">
                <h2 class="text-4xl font-bold primary-text pl-8 mr-10">ADMIN</h2>
                <div class="relative w-full">
                    <i class="fas fa-search absolute left-5 top-5 text-[#A8A8AC] text-2xl"></i>
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search transactions..."
                        CssClass="w-full pl-14 pr-6 py-4 bg-[#f7f7f7] border border-[#E56441] rounded-full focus:outline-none focus:ring-2 focus:ring-[#E56441] text-lg" />
                </div>
            </div>
        </header>

        <!-- Sidebar -->
        <aside class="fixed top-0 left-0 w-56 min-h-screen bg-white custom-shadow pt-24 z-0">
            <div class="p-4 h-full flex flex-col">
                <div class="mb-8 text-center">
                    <h2 class="text-2xl font-bold primary-text">PARES POS</h2>
                </div>
                <nav class="space-y-4 flex-grow">
                    <a href="Dashboard.aspx" class="nav-item hover:bg-gray-100 text-gray-700">
                        <i class="fas fa-th-large"></i><span class="text-lg">Dashboard</span>
                    </a>
                    <a href="Products.aspx" class="nav-item hover:bg-gray-100 text-gray-700">
                        <i class="fas fa-box"></i><span class="text-lg">Products</span>
                    </a>
                    <a href="SalesReport.aspx" class="nav-item active text-white">
                        <i class="fas fa-chart-bar"></i><span class="text-lg">Sales Report</span>
                    </a>
                    <a href="ManageAccount.aspx" class="nav-item hover:bg-gray-100 text-gray-700">
                        <i class="fas fa-users"></i><span class="text-lg">Manage Accounts</span>
                    </a>
                </nav>
                <div class="mt-auto border-t border-gray-200 pt-6">
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click"
                        CssClass="nav-item hover:bg-red-100 text-gray-700 hover:text-red-600">
                        <i class="fas fa-sign-out-alt"></i><span class="text-lg">Logout</span>
                    </asp:LinkButton>
                </div>
            </div>
        </aside>

        <!-- Mobile Sidebar Button -->
        <button type="button" id="mobileSidebarToggle"
            class="md:hidden fixed bottom-6 right-6 z-20 h-16 w-16 rounded-full primary-bg text-white shadow-lg flex items-center justify-center">
            <i class="fas fa-bars text-2xl"></i>
        </button>

        <!-- Main Content -->
        <main class="md:ml-64 pt-28 px-6 pb-8">
            <div class="mb-8 flex justify-between items-center">
                <h1 class="text-3xl font-bold text-gray-800">Sales Report</h1>
                <div class="flex items-center">
                    <asp:DropDownList ID="ddlDateRange" runat="server" CssClass="date-selector" AutoPostBack="true" OnSelectedIndexChanged="ddlDateRange_SelectedIndexChanged">
                        <asp:ListItem Text="Last 7 Days" Value="7" />
                        <asp:ListItem Text="Last 30 Days" Value="30" Selected="True" />
                        <asp:ListItem Text="Last 90 Days" Value="90" />
                    </asp:DropDownList>
                    <button type="button" class="print-button" onclick="window.print();">
                        <i class="fas fa-print"></i> Print Report
                    </button>
                </div>
            </div>

            <!-- Report Tabs -->
            <div class="mb-6 flex space-x-4">
                <asp:LinkButton ID="btnDailyTab" runat="server" CssClass="report-tab active" OnClick="btnDailyTab_Click">
                    Daily Report
                </asp:LinkButton>
                <asp:LinkButton ID="btnWeeklyTab" runat="server" CssClass="report-tab" OnClick="btnWeeklyTab_Click">
                    Weekly Report
                </asp:LinkButton>
                <asp:LinkButton ID="btnMonthlyTab" runat="server" CssClass="report-tab" OnClick="btnMonthlyTab_Click">
                    Monthly Report
                </asp:LinkButton>
            </div>

            <!-- Daily Report -->
            <div id="dailyReport" class="tab-content active">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <!-- Total Sales -->
                    <div class="analytics-card">
                        <div class="analytics-label">Today's Revenue</div>
                        <div class="analytics-value primary-text">
                            <asp:Literal ID="litDailyRevenue" runat="server"></asp:Literal>
                        </div>
                        <div class="flex items-center">
                            <asp:Literal ID="litDailyRevenueCompare" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <!-- Orders -->
                    <div class="analytics-card">
                        <div class="analytics-label">Today's Orders</div>
                        <div class="analytics-value primary-text">
                            <asp:Literal ID="litDailyOrders" runat="server"></asp:Literal>
                        </div>
                        <div class="flex items-center">
                            <asp:Literal ID="litDailyOrdersCompare" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <!-- Average Order Value -->
                    <div class="analytics-card">
                        <div class="analytics-label">Avg. Order Value</div>
                        <div class="analytics-value primary-text">
                            <asp:Literal ID="litDailyAOV" runat="server"></asp:Literal>
                        </div>
                        <div class="flex items-center">
                            <asp:Literal ID="litDailyAOVCompare" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <!-- Top Product -->
                    <div class="analytics-card">
                        <div class="analytics-label">Top Product</div>
                        <div class="mt-2 font-semibold text-xl">
                            <asp:Literal ID="litDailyTopProduct" runat="server"></asp:Literal>
                        </div>
                        <div class="mt-2 text-lg">
                            <asp:Literal ID="litDailyTopProductSales" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>

                <!-- Hourly Performance Chart -->
                <div class="mt-8">
                    <h3 class="text-xl font-semibold mb-4">Hourly Performance</h3>
                    <div class="chart-container">
                        <div class="flex h-full items-center justify-center">
                            <p class="text-center text-gray-500">
                                <i class="fas fa-chart-line text-5xl mb-4 block text-gray-300"></i>
                                Analytics visualization would appear here
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Daily Insights -->
                <div class="mt-8 bg-white p-6 rounded-xl shadow-sm">
                    <h3 class="text-xl font-semibold mb-4">Daily Insights</h3>
                    <div class="space-y-4">
                        <div class="flex items-start">
                            <div class="rounded-full p-2 bg-green-100 text-green-600 mr-4">
                                <i class="fas fa-arrow-trend-up"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Peak Hours</h4>
                                <p class="text-gray-600"><asp:Literal ID="litDailyPeakHours" runat="server"></asp:Literal></p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="rounded-full p-2 bg-blue-100 text-blue-600 mr-4">
                                <i class="fas fa-sack-dollar"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Average Transaction Size</h4>
                                <p class="text-gray-600"><asp:Literal ID="litDailyAvgTransaction" runat="server"></asp:Literal></p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="rounded-full p-2 bg-amber-100 text-amber-600 mr-4">
                                <i class="fas fa-star"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Popular Items</h4>
                                <p class="text-gray-600"><asp:Literal ID="litDailyPopularItems" runat="server"></asp:Literal></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Weekly Report -->
            <div id="weeklyReport" class="tab-content">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <!-- Total Sales -->
                    <div class="analytics-card">
                        <div class="analytics-label">Weekly Revenue</div>
                        <div class="analytics-value primary-text">
                            <asp:Literal ID="litWeeklyRevenue" runat="server"></asp:Literal>
                        </div>
                        <div class="flex items-center">
                            <asp:Literal ID="litWeeklyRevenueCompare" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <!-- Orders -->
                    <div class="analytics-card">
                        <div class="analytics-label">Weekly Orders</div>
                        <div class="analytics-value primary-text">
                            <asp:Literal ID="litWeeklyOrders" runat="server"></asp:Literal>
                        </div>
                        <div class="flex items-center">
                            <asp:Literal ID="litWeeklyOrdersCompare" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <!-- Average Order Value -->
                    <div class="analytics-card">
                        <div class="analytics-label">Avg. Order Value</div>
                        <div class="analytics-value primary-text">
                            <asp:Literal ID="litWeeklyAOV" runat="server"></asp:Literal>
                        </div>
                        <div class="flex items-center">
                            <asp:Literal ID="litWeeklyAOVCompare" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <!-- Top Product -->
                    <div class="analytics-card">
                        <div class="analytics-label">Top Product</div>
                        <div class="mt-2 font-semibold text-xl">
                            <asp:Literal ID="litWeeklyTopProduct" runat="server"></asp:Literal>
                        </div>
                        <div class="mt-2 text-lg">
                            <asp:Literal ID="litWeeklyTopProductSales" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>

                <!-- Daily Comparison Chart -->
                <div class="mt-8">
                    <h3 class="text-xl font-semibold mb-4">Daily Comparison</h3>
                    <div class="chart-container">
                        <div class="flex h-full items-center justify-center">
                            <p class="text-center text-gray-500">
                                <i class="fas fa-chart-bar text-5xl mb-4 block text-gray-300"></i>
                                Analytics visualization would appear here
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Weekly Insights -->
                <div class="mt-8 bg-white p-6 rounded-xl shadow-sm">
                    <h3 class="text-xl font-semibold mb-4">Weekly Insights</h3>
                    <div class="space-y-4">
                        <div class="flex items-start">
                            <div class="rounded-full p-2 bg-green-100 text-green-600 mr-4">
                                <i class="fas fa-calendar-day"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Best Performing Day</h4>
                                <p class="text-gray-600"><asp:Literal ID="litWeeklyBestDay" runat="server"></asp:Literal></p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="rounded-full p-2 bg-blue-100 text-blue-600 mr-4">
                                <i class="fas fa-chart-pie"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Category Performance</h4>
                                <p class="text-gray-600"><asp:Literal ID="litWeeklyCategoryPerf" runat="server"></asp:Literal></p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="rounded-full p-2 bg-amber-100 text-amber-600 mr-4">
                                <i class="fas fa-arrow-trend-up"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Growth Trend</h4>
                                <p class="text-gray-600"><asp:Literal ID="litWeeklyGrowth" runat="server"></asp:Literal></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Monthly Report -->
            <div id="monthlyReport" class="tab-content">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <!-- Total Sales -->
                    <div class="analytics-card">
                        <div class="analytics-label">Monthly Revenue</div>
                        <div class="analytics-value primary-text">
                            <asp:Literal ID="litMonthlyRevenue" runat="server"></asp:Literal>
                        </div>
                        <div class="flex items-center">
                            <asp:Literal ID="litMonthlyRevenueCompare" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <!-- Orders -->
                    <div class="analytics-card">
                        <div class="analytics-label">Monthly Orders</div>
                        <div class="analytics-value primary-text">
                            <asp:Literal ID="litMonthlyOrders" runat="server"></asp:Literal>
                        </div>
                        <div class="flex items-center">
                            <asp:Literal ID="litMonthlyOrdersCompare" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <!-- Average Order Value -->
                    <div class="analytics-card">
                        <div class="analytics-label">Avg. Order Value</div>
                        <div class="analytics-value primary-text">
                            <asp:Literal ID="litMonthlyAOV" runat="server"></asp:Literal>
                        </div>
                        <div class="flex items-center">
                            <asp:Literal ID="litMonthlyAOVCompare" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <!-- Top Product -->
                    <div class="analytics-card">
                        <div class="analytics-label">Top Product</div>
                        <div class="mt-2 font-semibold text-xl">
                            <asp:Literal ID="litMonthlyTopProduct" runat="server"></asp:Literal>
                        </div>
                        <div class="mt-2 text-lg">
                            <asp:Literal ID="litMonthlyTopProductSales" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>

                <!-- Monthly Trend Chart -->
                <div class="mt-8">
                    <h3 class="text-xl font-semibold mb-4">Monthly Trend</h3>
                    <div class="chart-container">
                        <div class="flex h-full items-center justify-center">
                            <p class="text-center text-gray-500">
                                <i class="fas fa-chart-line text-5xl mb-4 block text-gray-300"></i>
                                Analytics visualization would appear here
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Monthly Insights -->
                <div class="mt-8 bg-white p-6 rounded-xl shadow-sm">
                    <h3 class="text-xl font-semibold mb-4">Monthly Insights</h3>
                    <div class="space-y-4">
                        <div class="flex items-start">
                            <div class="rounded-full p-2 bg-green-100 text-green-600 mr-4">
                                <i class="fas fa-calendar-week"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Best Performing Week</h4>
                                <p class="text-gray-600"><asp:Literal ID="litMonthlyBestWeek" runat="server"></asp:Literal></p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="rounded-full p-2 bg-blue-100 text-blue-600 mr-4">
                                <i class="fas fa-users"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Customer Growth</h4>
                                <p class="text-gray-600"><asp:Literal ID="litMonthlyCustomerGrowth" runat="server"></asp:Literal></p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="rounded-full p-2 bg-amber-100 text-amber-600 mr-4">
                                <i class="fas fa-lightbulb"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Recommendations</h4>
                                <p class="text-gray-600"><asp:Literal ID="litMonthlyRecommendations" runat="server"></asp:Literal></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </form>

    <script>
        // Tab switching functionality
        document.addEventListener('DOMContentLoaded', function () {
            // Handle mobile sidebar toggle
            const mobileSidebarToggle = document.getElementById('mobileSidebarToggle');
            const sidebar = document.querySelector('aside');

            if (mobileSidebarToggle) {
                mobileSidebarToggle.addEventListener('click', function () {
                    sidebar.classList.toggle('translate-x-0');
                    sidebar.classList.toggle('-translate-x-full');
                });
            }

            // Client-side tab switching as fallback
            const tabButtons = document.querySelectorAll('.report-tab');
            const tabContents = document.querySelectorAll('.tab-content');

            tabButtons.forEach(button => {
                button.addEventListener('click', function (e) {
                    // This will only run if the server-side event doesn't trigger first
                    const tabId = this.id.replace('btn', '').replace('Tab', '').toLowerCase() + 'Report';

                    // Remove active class from all tabs and contents
                    tabButtons.forEach(btn => btn.classList.remove('active'));
                    tabContents.forEach(content => content.classList.remove('active'));

                    // Add active class to current tab and content
                    this.classList.add('active');
                    document.getElementById(tabId).classList.add('active');
                });
            });
        });
    </script>
</body>
</html><%--  --%>