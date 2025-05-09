using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PARESPOS.Pages.Admin
{
    public partial class SalesReport : System.Web.UI.Page
    {
        // Mock data for sales report
        private class SalesData
        {
            public DateTime Date { get; set; }
            public double Revenue { get; set; }
            public int Orders { get; set; }
            public string TopProduct { get; set; }
            public int TopProductQuantity { get; set; }
            public double TopProductRevenue { get; set; }
        }

        private class Product
        {
            public string Name { get; set; }
            public int Quantity { get; set; }
            public double Revenue { get; set; }
            public string Category { get; set; }
        }

        // Mock data
        private List<SalesData> _mockSalesData;
        private List<Product> _mockProducts;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Generate mock data
            GenerateMockData();

            if (!IsPostBack)
            {
                LoadReportData();
            }
        }

        private void GenerateMockData()
        {
            // Create mock sales data for the last 90 days
            Random random = new Random();
            DateTime today = DateTime.Today;
            _mockSalesData = new List<SalesData>();

            // Mock products
            _mockProducts = new List<Product>
            {
                new Product { Name = "Classic Beef Pares", Category = "Main Dish", Quantity = 0, Revenue = 0 },
                new Product { Name = "Special Pares", Category = "Main Dish", Quantity = 0, Revenue = 0 },
                new Product { Name = "Beef Mami", Category = "Noodles", Quantity = 0, Revenue = 0 },
                new Product { Name = "Pares Mami", Category = "Combo", Quantity = 0, Revenue = 0 },
                new Product { Name = "Fried Rice", Category = "Rice", Quantity = 0, Revenue = 0 },
                new Product { Name = "Plain Rice", Category = "Rice", Quantity = 0, Revenue = 0 },
                new Product { Name = "Iced Tea", Category = "Drinks", Quantity = 0, Revenue = 0 },
                new Product { Name = "Softdrinks", Category = "Drinks", Quantity = 0, Revenue = 0 }
            };

            // Generate daily data
            for (int i = 90; i >= 0; i--)
            {
                DateTime date = today.AddDays(-i);

                // Create variation in daily sales
                double baseRevenue = 8000 + (Math.Sin(i * 0.3) * 2000);

                // Weekend boost
                if (date.DayOfWeek == DayOfWeek.Friday || date.DayOfWeek == DayOfWeek.Saturday)
                {
                    baseRevenue *= 1.3;
                }

                // Monthly pattern (higher at start/end of month)
                double monthFactor = 1.0;
                if (date.Day <= 5 || date.Day >= 25)
                {
                    monthFactor = 1.15;
                }

                // Growth trend over time
                double growthFactor = 1.0 + (i * 0.001);

                double dailyRevenue = baseRevenue * monthFactor / growthFactor;
                int dailyOrders = (int)(dailyRevenue / 200);

                // Randomize top product each day
                int productIndex = random.Next(_mockProducts.Count);
                string topProduct = _mockProducts[productIndex].Name;
                int topProductQty = (int)(dailyOrders * 0.3);
                double topProductRevenue = topProductQty * (random.NextDouble() * 50 + 100);

                _mockSalesData.Add(new SalesData
                {
                    Date = date,
                    Revenue = dailyRevenue,
                    Orders = dailyOrders,
                    TopProduct = topProduct,
                    TopProductQuantity = topProductQty,
                    TopProductRevenue = topProductRevenue
                });

                // Update products statistics
                _mockProducts[productIndex].Quantity += topProductQty;
                _mockProducts[productIndex].Revenue += topProductRevenue;
            }
        }

        protected void LoadReportData()
        {
            // Default to showing daily report
            LoadDailyReport();
            LoadWeeklyReport();
            LoadMonthlyReport();
        }

        private void LoadDailyReport()
        {
            // Get today's data
            SalesData today = _mockSalesData.FirstOrDefault(d => d.Date.Date == DateTime.Today);

            // Get yesterday's data for comparison
            SalesData yesterday = _mockSalesData.FirstOrDefault(d => d.Date.Date == DateTime.Today.AddDays(-1));

            if (today != null)
            {
                // Set revenue
                litDailyRevenue.Text = $"₱{today.Revenue:N2}";

                // Set revenue comparison
                if (yesterday != null)
                {
                    double revenueChange = ((today.Revenue - yesterday.Revenue) / yesterday.Revenue) * 100;
                    string trendIcon = revenueChange >= 0 ?
                        "<i class='fas fa-arrow-up mr-1 trend-up'></i>" :
                        "<i class='fas fa-arrow-down mr-1 trend-down'></i>";

                    litDailyRevenueCompare.Text = $"{trendIcon} {Math.Abs(revenueChange):N1}% from yesterday";
                }

                // Set orders
                litDailyOrders.Text = today.Orders.ToString();

                // Set orders comparison
                if (yesterday != null)
                {
                    double ordersChange = ((double)(today.Orders - yesterday.Orders) / yesterday.Orders) * 100;
                    string trendIcon = ordersChange >= 0 ?
                        "<i class='fas fa-arrow-up mr-1 trend-up'></i>" :
                        "<i class='fas fa-arrow-down mr-1 trend-down'></i>";

                    litDailyOrdersCompare.Text = $"{trendIcon} {Math.Abs(ordersChange):N1}% from yesterday";
                }

                // Set AOV (Average Order Value)
                double aov = today.Revenue / today.Orders;
                litDailyAOV.Text = $"₱{aov:N2}";

                // Set AOV comparison
                if (yesterday != null)
                {
                    double yesterdayAOV = yesterday.Revenue / yesterday.Orders;
                    double aovChange = ((aov - yesterdayAOV) / yesterdayAOV) * 100;
                    string trendIcon = aovChange >= 0 ?
                        "<i class='fas fa-arrow-up mr-1 trend-up'></i>" :
                        "<i class='fas fa-arrow-down mr-1 trend-down'></i>";

                    litDailyAOVCompare.Text = $"{trendIcon} {Math.Abs(aovChange):N1}% from yesterday";
                }

                // Set top product
                litDailyTopProduct.Text = today.TopProduct;
                litDailyTopProductSales.Text = $"{today.TopProductQuantity} units · ₱{today.TopProductRevenue:N2}";

                // Set insights
                litDailyPeakHours.Text = "11:00 AM - 1:00 PM and 5:00 PM - 7:00 PM";
                litDailyAvgTransaction.Text = $"₱{aov:N2} per transaction";
                litDailyPopularItems.Text = $"{today.TopProduct}, Fried Rice, and Iced Tea";
            }
        }

        private void LoadWeeklyReport()
        {
            // Calculate week ranges
            DateTime today = DateTime.Today;
            DateTime weekStart = today.AddDays(-(int)today.DayOfWeek);
            DateTime weekEnd = weekStart.AddDays(6);
            DateTime prevWeekStart = weekStart.AddDays(-7);
            DateTime prevWeekEnd = weekStart.AddDays(-1);

            // Get current week data
            var currentWeekData = _mockSalesData
                .Where(d => d.Date >= weekStart && d.Date <= weekEnd)
                .ToList();

            // Get previous week data
            var prevWeekData = _mockSalesData
                .Where(d => d.Date >= prevWeekStart && d.Date <= prevWeekEnd)
                .ToList();

            if (currentWeekData.Any())
            {
                // Calculate totals for current week
                double weeklyRevenue = currentWeekData.Sum(d => d.Revenue);
                int weeklyOrders = currentWeekData.Sum(d => d.Orders);
                double weeklyAOV = weeklyRevenue / weeklyOrders;

                // Set weekly revenue
                litWeeklyRevenue.Text = $"₱{weeklyRevenue:N2}";

                // Set weekly revenue comparison
                if (prevWeekData.Any())
                {
                    double prevWeekRevenue = prevWeekData.Sum(d => d.Revenue);
                    double revenueChange = ((weeklyRevenue - prevWeekRevenue) / prevWeekRevenue) * 100;
                    string trendIcon = revenueChange >= 0 ?
                        "<i class='fas fa-arrow-up mr-1 trend-up'></i>" :
                        "<i class='fas fa-arrow-down mr-1 trend-down'></i>";

                    litWeeklyRevenueCompare.Text = $"{trendIcon} {Math.Abs(revenueChange):N1}% from last week";
                }

                // Set weekly orders
                litWeeklyOrders.Text = weeklyOrders.ToString();

                // Set weekly orders comparison
                if (prevWeekData.Any())
                {
                    int prevWeekOrders = prevWeekData.Sum(d => d.Orders);
                    double ordersChange = ((double)(weeklyOrders - prevWeekOrders) / prevWeekOrders) * 100;
                    string trendIcon = ordersChange >= 0 ?
                        "<i class='fas fa-arrow-up mr-1 trend-up'></i>" :
                        "<i class='fas fa-arrow-down mr-1 trend-down'></i>";

                    litWeeklyOrdersCompare.Text = $"{trendIcon} {Math.Abs(ordersChange):N1}% from last week";
                }

                // Set weekly AOV
                litWeeklyAOV.Text = $"₱{weeklyAOV:N2}";

                // Set weekly AOV comparison
                if (prevWeekData.Any())
                {
                    double prevWeekAOV = prevWeekData.Sum(d => d.Revenue) / prevWeekData.Sum(d => d.Orders);
                    double aovChange = ((weeklyAOV - prevWeekAOV) / prevWeekAOV) * 100;
                    string trendIcon = aovChange >= 0 ?
                        "<i class='fas fa-arrow-up mr-1 trend-up'></i>" :
                        "<i class='fas fa-arrow-down mr-1 trend-down'></i>";

                    litWeeklyAOVCompare.Text = $"{trendIcon} {Math.Abs(aovChange):N1}% from last week";
                }

                // Find top product for the week
                var productGroups = currentWeekData
                    .GroupBy(d => d.TopProduct)
                    .Select(g => new
                    {
                        ProductName = g.Key,
                        TotalQuantity = g.Sum(d => d.TopProductQuantity),
                        TotalRevenue = g.Sum(d => d.TopProductRevenue)
                    })
                    .OrderByDescending(p => p.TotalRevenue)
                    .ToList();

                if (productGroups.Any())
                {
                    var topProduct = productGroups.First();
                    litWeeklyTopProduct.Text = topProduct.ProductName;
                    litWeeklyTopProductSales.Text = $"{topProduct.TotalQuantity} units · ₱{topProduct.TotalRevenue:N2}";
                }

                // Find best performing day of the week
                var bestPerformingDay = currentWeekData
                    .OrderByDescending(d => d.Revenue)
                    .FirstOrDefault();

                if (bestPerformingDay != null)
                {
                    litWeeklyBestDay.Text = $"{bestPerformingDay.Date.ToString("dddd")} with ₱{bestPerformingDay.Revenue:N2} in sales";
                }

                // Set category performance insight
                litWeeklyCategoryPerf.Text = "Main Dishes leading with 45% of sales, followed by Combo Meals at 30%";

                // Set growth trend insight
                if (prevWeekData.Any())
                {
                    double growthRate = ((weeklyRevenue - prevWeekData.Sum(d => d.Revenue)) / prevWeekData.Sum(d => d.Revenue)) * 100;
                    litWeeklyGrowth.Text = growthRate >= 0 ?
                        $"Up {growthRate:N1}% compared to last week" :
                        $"Down {Math.Abs(growthRate):N1}% compared to last week";
                }
            }
        }

        private void LoadMonthlyReport()
        {
            // Calculate month ranges
            DateTime today = DateTime.Today;
            DateTime monthStart = new DateTime(today.Year, today.Month, 1);
            DateTime monthEnd = monthStart.AddMonths(1).AddDays(-1);
            DateTime prevMonthStart = monthStart.AddMonths(-1);
            DateTime prevMonthEnd = monthStart.AddDays(-1);

            // Get current month data
            var currentMonthData = _mockSalesData
                .Where(d => d.Date >= monthStart && d.Date <= today) // Only include days up to today
                .ToList();

            // Get previous month data
            var prevMonthData = _mockSalesData
                .Where(d => d.Date >= prevMonthStart && d.Date <= prevMonthEnd)
                .ToList();

            if (currentMonthData.Any())
            {
                // Calculate totals for current month
                double monthlyRevenue = currentMonthData.Sum(d => d.Revenue);
                int monthlyOrders = currentMonthData.Sum(d => d.Orders);
                double monthlyAOV = monthlyRevenue / monthlyOrders;

                // Set monthly revenue
                litMonthlyRevenue.Text = $"₱{monthlyRevenue:N2}";

                // Set monthly revenue comparison
                if (prevMonthData.Any())
                {
                    double prevMonthRevenue = prevMonthData.Sum(d => d.Revenue);
                    double revenueChange = ((monthlyRevenue - prevMonthRevenue) / prevMonthRevenue) * 100;
                    string trendIcon = revenueChange >= 0 ?
                        "<i class='fas fa-arrow-up mr-1 trend-up'></i>" :
                        "<i class='fas fa-arrow-down mr-1 trend-down'></i>";

                    litMonthlyRevenueCompare.Text = $"{trendIcon} {Math.Abs(revenueChange):N1}% from last month";
                }

                // Set monthly orders
                litMonthlyOrders.Text = monthlyOrders.ToString();

                // Set monthly orders comparison
                if (prevMonthData.Any())
                {
                    int prevMonthOrders = prevMonthData.Sum(d => d.Orders);
                    double ordersChange = ((double)(monthlyOrders - prevMonthOrders) / prevMonthOrders) * 100;
                    string trendIcon = ordersChange >= 0 ?
                        "<i class='fas fa-arrow-up mr-1 trend-up'></i>" :
                        "<i class='fas fa-arrow-down mr-1 trend-down'></i>";

                    litMonthlyOrdersCompare.Text = $"{trendIcon} {Math.Abs(ordersChange):N1}% from last month";
                }

                // Set monthly AOV
                litMonthlyAOV.Text = $"₱{monthlyAOV:N2}";

                // Set monthly AOV comparison
                if (prevMonthData.Any())
                {
                    double prevMonthAOV = prevMonthData.Sum(d => d.Revenue) / prevMonthData.Sum(d => d.Orders);
                    double aovChange = ((monthlyAOV - prevMonthAOV) / prevMonthAOV) * 100;
                    string trendIcon = aovChange >= 0 ?
                        "<i class='fas fa-arrow-up mr-1 trend-up'></i>" :
                        "<i class='fas fa-arrow-down mr-1 trend-down'></i>";

                    litMonthlyAOVCompare.Text = $"{trendIcon} {Math.Abs(aovChange):N1}% from last month";
                }

                // Find top product for the month
                var productGroups = currentMonthData
                    .GroupBy(d => d.TopProduct)
                    .Select(g => new
                    {
                        ProductName = g.Key,
                        TotalQuantity = g.Sum(d => d.TopProductQuantity),
                        TotalRevenue = g.Sum(d => d.TopProductRevenue)
                    })
                    .OrderByDescending(p => p.TotalRevenue)
                    .ToList();

                if (productGroups.Any())
                {
                    var topProduct = productGroups.First();
                    litMonthlyTopProduct.Text = topProduct.ProductName;
                    litMonthlyTopProductSales.Text = $"{topProduct.TotalQuantity} units · ₱{topProduct.TotalRevenue:N2}";
                }

                // Group by week for finding best performing week
                var weeklyData = currentMonthData
                    .GroupBy(d => System.Globalization.CultureInfo.CurrentCulture.Calendar.GetWeekOfYear(
                        d.Date, System.Globalization.CalendarWeekRule.FirstDay, DayOfWeek.Sunday))
                    .Select(g => new
                    {
                        WeekNumber = g.Key,
                        StartDate = g.Min(d => d.Date),
                        EndDate = g.Max(d => d.Date),
                        TotalRevenue = g.Sum(d => d.Revenue)
                    })
                    .OrderByDescending(w => w.TotalRevenue)
                    .ToList();

                if (weeklyData.Any())
                {
                    var bestWeek = weeklyData.First();
                    litMonthlyBestWeek.Text = $"Week of {bestWeek.StartDate.ToString("MMM d")} - {bestWeek.EndDate.ToString("MMM d")} with ₱{bestWeek.TotalRevenue:N2} in sales";
                }

                // Set customer growth insight (mock data)
                double customerGrowth = 8.5; // Mock growth percentage
                litMonthlyCustomerGrowth.Text = $"Customer base growing at {customerGrowth}% this month with increased repeat visits";

                // Set recommendations
                litMonthlyRecommendations.Text = "Focus on promoting combo meals on weekdays to boost average transaction value";
            }
        }

        protected void btnDailyTab_Click(object sender, EventArgs e)
        {
            // Set active tab
            btnDailyTab.CssClass = "report-tab active";
            btnWeeklyTab.CssClass = "report-tab";
            btnMonthlyTab.CssClass = "report-tab";

            // Set active content via JavaScript
            ScriptManager.RegisterStartupScript(this, GetType(), "showDailyTab",
                "document.getElementById('dailyReport').classList.add('active');" +
                "document.getElementById('weeklyReport').classList.remove('active');" +
                "document.getElementById('monthlyReport').classList.remove('active');", true);
        }

        protected void btnWeeklyTab_Click(object sender, EventArgs e)
        {
            // Set active tab
            btnDailyTab.CssClass = "report-tab";
            btnWeeklyTab.CssClass = "report-tab active";
            btnMonthlyTab.CssClass = "report-tab";

            // Set active content via JavaScript
            ScriptManager.RegisterStartupScript(this, GetType(), "showWeeklyTab",
                "document.getElementById('dailyReport').classList.remove('active');" +
                "document.getElementById('weeklyReport').classList.add('active');" +
                "document.getElementById('monthlyReport').classList.remove('active');", true);
        }

        protected void btnMonthlyTab_Click(object sender, EventArgs e)
        {
            // Set active tab
            btnDailyTab.CssClass = "report-tab";
            btnWeeklyTab.CssClass = "report-tab";
            btnMonthlyTab.CssClass = "report-tab active";

            // Set active content via JavaScript
            ScriptManager.RegisterStartupScript(this, GetType(), "showMonthlyTab",
                "document.getElementById('dailyReport').classList.remove('active');" +
                "document.getElementById('weeklyReport').classList.remove('active');" +
                "document.getElementById('monthlyReport').classList.add('active');", true);
        }

        protected void ddlDateRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            // This would normally filter data based on selection
            // For this mock implementation, we'll just reload the data
            LoadReportData();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Just redirect to login page
            Response.Redirect("~/Pages/Accounts/Login.aspx");
        }
    }
}