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
            // In a real application, fetch from database
            DataTable dt = new DataTable();
            dt.Columns.Add("CategoryID", typeof(int));
            dt.Columns.Add("CategoryName", typeof(string));

            // Add sample categories
            dt.Rows.Add(1, "Main Course");
            dt.Rows.Add(2, "Beverages");
            dt.Rows.Add(3, "Desserts");
            dt.Rows.Add(4, "Snacks");

            rptCategories.DataSource = dt;
            rptCategories.DataBind();
        }

        private void LoadProducts(string categoryFilter, string searchTerm = "")
        {
            // In a real application, fetch from database with proper filtering
            DataTable dt = new DataTable();
            dt.Columns.Add("ProductID", typeof(int));
            dt.Columns.Add("ProductName", typeof(string));
            dt.Columns.Add("CategoryID", typeof(int));
            dt.Columns.Add("CategoryName", typeof(string));
            dt.Columns.Add("Price", typeof(decimal));
            dt.Columns.Add("StockStatus", typeof(string));
            dt.Columns.Add("InStock", typeof(bool));
            dt.Columns.Add("ImageUrl", typeof(string));

            // Add sample products
            dt.Rows.Add(1, "Chicken Burger", 1, "Main Course", 8.99m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(2, "Cola", 2, "Beverages", 1.99m, "Low Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(3, "Chocolate Cake", 3, "Desserts", 4.99m, "Out of Stock", false, "/api/placeholder/400/320");
            dt.Rows.Add(4, "French Fries", 4, "Snacks", 3.49m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(5, "Veggie Burger", 1, "Main Course", 7.99m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(6, "Iced Tea", 2, "Beverages", 1.49m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(7, "Cheesecake", 3, "Desserts", 5.99m, "In Stock", true, "/api/placeholder/400/320");
            dt.Rows.Add(8, "Onion Rings", 4, "Snacks", 2.99m, "In Stock", true, "/api/placeholder/400/320");

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
                    return "absolute top-2 right-2 bg-success text-white text-xs px-2 py-1 rounded-full";
                case "Low Stock":
                    return "absolute top-2 right-2 bg-warning text-white text-xs px-2 py-1 rounded-full";
                case "Out of Stock":
                    return "absolute top-2 right-2 bg-danger text-white text-xs px-2 py-1 rounded-full";
                default:
                    return "absolute top-2 right-2 bg-success text-white text-xs px-2 py-1 rounded-full";
            }
        }

        #endregion

        #region Event Handlers

        protected void btnCategory_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string categoryId = btn.CommandArgument;

            // Update active category styling (would require AJAX in a real application)

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
            // In a real application, process payment and save order to database

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
                "alert('Payment completed successfully!');", true);
        }

        #endregion

        #region Order Management

        private void AddProductToOrder(int productId)
        {
            // In a real application, get product details from database
            // For demo, we'll use hardcoded values based on the sample data
            string productName = "";
            decimal price = 0;

            switch (productId)
            {
                case 1:
                    productName = "Chicken Burger";
                    price = 8.99m;
                    break;
                case 2:
                    productName = "Cola";
                    price = 1.99m;
                    break;
                case 3:
                    productName = "Chocolate Cake";
                    price = 4.99m;
                    break;
                case 4:
                    productName = "French Fries";
                    price = 3.49m;
                    break;
                case 5:
                    productName = "Veggie Burger";
                    price = 7.99m;
                    break;
                case 6:
                    productName = "Iced Tea";
                    price = 1.49m;
                    break;
                case 7:
                    productName = "Cheesecake";
                    price = 5.99m;
                    break;
                case 8:
                    productName = "Onion Rings";
                    price = 2.99m;
                    break;
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
            // Generate a random order number for demo purposes
            Random rnd = new Random();
            return rnd.Next(10000, 99999).ToString();
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