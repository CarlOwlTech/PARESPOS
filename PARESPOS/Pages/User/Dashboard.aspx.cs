using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;

namespace PARESPOS.Pages.User
{
    public partial class Dashboard : System.Web.UI.Page
    {
        // Properties to store current order items
        private List<OrderItem> CurrentOrder
        {
            get
            {
                if (Session["CurrentOrder"] == null)
                {
                    Session["CurrentOrder"] = new List<OrderItem>();
                }
                return (List<OrderItem>)Session["CurrentOrder"];
            }
            set
            {
                Session["CurrentOrder"] = value;
            }
        }

        // Current order number
        private string OrderNumber
        {
            get
            {
                if (Session["OrderNumber"] == null)
                {
                    Session["OrderNumber"] = GenerateOrderNumber();
                }
                return Session["OrderNumber"].ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Display order number
                lblOrderNumber.Text = OrderNumber;

                // Load categories
                LoadCategories();

                // Load all products initially
                LoadProducts("All");

                // Bind order items
                UpdateOrderSummary();
            }
        }

        #region Product Loading

        private void LoadCategories()
        {
            // Use sample data instead of database connection
            DataTable dt = new DataTable();
            dt.Columns.Add("CategoryID", typeof(int));
            dt.Columns.Add("CategoryName", typeof(string));

            // Add Pares-specific categories
            dt.Rows.Add(1, "Pares");
            dt.Rows.Add(2, "Rice Meals");
            dt.Rows.Add(3, "Noodles");
            dt.Rows.Add(4, "Side Dishes");
            dt.Rows.Add(5, "Beverages");
            dt.Rows.Add(6, "Desserts");

            rptCategories.DataSource = dt;
            rptCategories.DataBind();
        }

        private void LoadProducts(string categoryFilter, string searchTerm = "")
        {
            // Use sample data instead of database connection
            DataTable dt = new DataTable();
            dt.Columns.Add("ProductID", typeof(int));
            dt.Columns.Add("ProductName", typeof(string));
            dt.Columns.Add("CategoryID", typeof(int));
            dt.Columns.Add("CategoryName", typeof(string));
            dt.Columns.Add("Price", typeof(decimal));
            dt.Columns.Add("StockStatus", typeof(string));
            dt.Columns.Add("InStock", typeof(bool));
            dt.Columns.Add("ImageUrl", typeof(string));

            // Add Pares-specific sample products
            dt.Rows.Add(101, "Beef Pares", 1, "Pares", 85.00m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(102, "Special Pares", 1, "Pares", 95.00m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(103, "Pares with Egg", 1, "Pares", 105.00m, "In Stock", true, "/api/placeholder/400/320");

            dt.Rows.Add(201, "Tapsilog", 2, "Rice Meals", 90.00m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(202, "Silog", 2, "Rice Meals", 75.00m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(203, "Longsilog", 2, "Rice Meals", 85.00m, "Low Stock", true, "/api/placeholder/400/320");

            dt.Rows.Add(301, "Beef Mami", 3, "Noodles", 95.00m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(302, "Wonton Noodles", 3, "Noodles", 100.00m, "Out of Stock", false, "/api/placeholder/400/320");

            dt.Rows.Add(401, "Siomai (4pcs)", 4, "Side Dishes", 55.00m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(402, "Spring Rolls", 4, "Side Dishes", 45.00m, "In Stock", true, "/api/placeholder/400/320");

            dt.Rows.Add(501, "Iced Tea", 5, "Beverages", 35.00m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(502, "Soda", 5, "Beverages", 45.00m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(503, "Hot Tea", 5, "Beverages", 30.00m, "Low Stock", true, "/api/placeholder/400/320");

            dt.Rows.Add(601, "Leche Flan", 6, "Desserts", 50.00m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(602, "Halo-Halo", 6, "Desserts", 75.00m, "Out of Stock", false, "/api/placeholder/400/320");

            // Filter by category if specified
            if (categoryFilter != "All" && int.TryParse(categoryFilter, out int categoryId))
            {
                DataView dv = dt.DefaultView;
                dv.RowFilter = $"CategoryID = {categoryId}";
                dt = dv.ToTable();
            }

            // Filter by search term if provided
            if (!string.IsNullOrEmpty(searchTerm))
            {
                DataView dv = dt.DefaultView;
                dv.RowFilter = $"ProductName LIKE '%{searchTerm}%'";
                dt = dv.ToTable();
            }

            rptProducts.DataSource = dt;
            rptProducts.DataBind();
        }

        protected string GetStockStatusClass(string status)
        {
            switch (status)
            {
                case "In Stock":
                    return "absolute top-2 right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full";
                case "Low Stock":
                    return "absolute top-2 right-2 bg-yellow-500 text-white text-xs px-2 py-1 rounded-full";
                case "Out of Stock":
                    return "absolute top-2 right-2 bg-red-500 text-white text-xs px-2 py-1 rounded-full";
                default:
                    return "absolute top-2 right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full";
            }
        }

        #endregion

        #region Event Handlers

        protected void btnCategory_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string categoryId = btn.CommandArgument;

            // Load products for the selected category
            LoadProducts(categoryId);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            LoadProducts("All", searchTerm);
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                AddProductToOrder(productId);
            }
        }

        protected void rptOrderItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "RemoveItem")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                RemoveProductFromOrder(productId);
            }
        }

        protected void btnClearOrder_Click(object sender, EventArgs e)
        {
            // Clear the current order
            CurrentOrder.Clear();
            UpdateOrderSummary();
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            if (CurrentOrder.Count > 0)
            {
                // Update modal amounts
                lblModalTotal.Text = lblTotal.Text;

                // Show the checkout modal using JavaScript
                ScriptManager.RegisterStartupScript(this, GetType(), "showModal", "showCheckoutModal();", true);
            }
            else
            {
                // Show a message if the order is empty
                ScriptManager.RegisterStartupScript(this, GetType(), "emptyOrder",
                    "alert('Please add items to your order before checkout.');", true);
            }
        }

        protected void btnCashPayment_Click(object sender, EventArgs e)
        {
            // Show cash payment panel
            pnlCashPayment.Visible = true;
            pnlChange.Visible = true;
        }

        protected void btnCardPayment_Click(object sender, EventArgs e)
        {
            // Hide cash payment panel as card payment wouldn't need change calculation
            pnlCashPayment.Visible = false;
            pnlChange.Visible = false;
        }

        protected void btnQuickAmount_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            decimal amount = Convert.ToDecimal(btn.CommandArgument);

            // Set the cash amount textbox
            txtCashAmount.Text = amount.ToString();

            // Calculate change
            decimal total = Convert.ToDecimal(lblTotal.Text);
            decimal change = amount - total;

            lblCashAmount.Text = amount.ToString("F2");
            lblChange.Text = (change > 0 ? change : 0).ToString("F2");
        }

        protected void btnCancelCheckout_Click(object sender, EventArgs e)
        {
            // Hide checkout modal
            ScriptManager.RegisterStartupScript(this, GetType(), "hideModal", "hideCheckoutModal();", true);
        }

        protected void btnCompletePayment_Click(object sender, EventArgs e)
        {
            // In a real application, we would save the order to database here
            // For this demo, we'll just clear the order and show a success message

            // Clear the current order
            CurrentOrder.Clear();

            // Generate a new order number
            Session["OrderNumber"] = GenerateOrderNumber();
            lblOrderNumber.Text = Session["OrderNumber"].ToString();

            // Update order summary
            UpdateOrderSummary();

            // Hide checkout modal
            ScriptManager.RegisterStartupScript(this, GetType(), "hideModal", "hideCheckoutModal();", true);

            // Show success message
            ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                "alert('Payment completed successfully! Receipt printed.');", true);
        }

        #endregion

        #region Order Management

        private void AddProductToOrder(int productId)
        {
            // Get product details from our sample data
            // In a real application, this would fetch from database
            string productName = "";
            decimal price = 0;

            // Find product details based on the product ID
            switch (productId)
            {
                case 101:
                    productName = "Beef Pares";
                    price = 85.00m;
                    break;
                case 102:
                    productName = "Special Pares";
                    price = 95.00m;
                    break;
                case 103:
                    productName = "Pares with Egg";
                    price = 105.00m;
                    break;
                case 201:
                    productName = "Tapsilog";
                    price = 90.00m;
                    break;
                case 202:
                    productName = "Silog";
                    price = 75.00m;
                    break;
                case 203:
                    productName = "Longsilog";
                    price = 85.00m;
                    break;
                case 301:
                    productName = "Beef Mami";
                    price = 95.00m;
                    break;
                case 302:
                    productName = "Wonton Noodles";
                    price = 100.00m;
                    break;
                case 401:
                    productName = "Siomai (4pcs)";
                    price = 55.00m;
                    break;
                case 402:
                    productName = "Spring Rolls";
                    price = 45.00m;
                    break;
                case 501:
                    productName = "Iced Tea";
                    price = 35.00m;
                    break;
                case 502:
                    productName = "Soda";
                    price = 45.00m;
                    break;
                case 503:
                    productName = "Hot Tea";
                    price = 30.00m;
                    break;
                case 601:
                    productName = "Leche Flan";
                    price = 50.00m;
                    break;
                case 602:
                    productName = "Halo-Halo";
                    price = 75.00m;
                    break;
                default:
                    // Handle unknown product
                    ScriptManager.RegisterStartupScript(this, GetType(), "unknownProduct",
                        "alert('Unknown product selected.');", true);
                    return;
            }

            // Check if product is already in order
            OrderItem existingItem = CurrentOrder.Find(item => item.ProductID == productId);
            if (existingItem != null)
            {
                // Increase quantity
                existingItem.Quantity++;
                existingItem.Subtotal = existingItem.Price * existingItem.Quantity;
            }
            else
            {
                // Add new item
                OrderItem newItem = new OrderItem
                {
                    ProductID = productId,
                    ProductName = productName,
                    Price = price,
                    Quantity = 1,
                    Subtotal = price
                };
                CurrentOrder.Add(newItem);
            }

            // Update order summary
            UpdateOrderSummary();
        }

        private void RemoveProductFromOrder(int productId)
        {
            // Find the product in order
            OrderItem itemToRemove = CurrentOrder.Find(item => item.ProductID == productId);
            if (itemToRemove != null)
            {
                if (itemToRemove.Quantity > 1)
                {
                    // Decrease quantity
                    itemToRemove.Quantity--;
                    itemToRemove.Subtotal = itemToRemove.Price * itemToRemove.Quantity;
                }
                else
                {
                    // Remove item completely
                    CurrentOrder.Remove(itemToRemove);
                }
            }

            // Update order summary
            UpdateOrderSummary();
        }

        private void UpdateOrderSummary()
        {
            // Bind order items to repeater
            rptOrderItems.DataSource = CurrentOrder;
            rptOrderItems.DataBind();

            // Calculate totals
            decimal subtotal = 0;
            foreach (OrderItem item in CurrentOrder)
            {
                subtotal += item.Subtotal;
            }

            // Tax rate is 12% (configurable)
            decimal taxRate = 12;
            decimal tax = subtotal * (taxRate / 100);
            decimal total = subtotal + tax;

            // Update labels
            lblSubtotal.Text = subtotal.ToString("F2");
            lblTaxRate.Text = taxRate.ToString();
            lblTax.Text = tax.ToString("F2");
            lblTotal.Text = total.ToString("F2");
        }

        private string GenerateOrderNumber()
        {
            // Generate an order number with PARES prefix and date
            string datePrefix = DateTime.Now.ToString("yyMMdd");
            Random rnd = new Random();
            return "PARES-" + datePrefix + "-" + rnd.Next(1000, 9999).ToString();
        }

        #endregion
    }

    // Class to represent an order item
    [Serializable]
    public class OrderItem
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public decimal Subtotal { get; set; }
    }
}