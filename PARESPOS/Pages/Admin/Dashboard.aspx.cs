using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;

namespace PARESPOS.Pages.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is authenticated (mockup check)
            if (!IsUserAuthenticated())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Load dashboard data
                LoadDashboardSummary();
                BindProductsGrid();
            }
        }

        private bool IsUserAuthenticated()
        {
            // For mockup purposes, always return true
            // In a real implementation, you would check session variables
            return true;
        }

        private void LoadDashboardSummary()
        {
            try
            {
                // Mock data for dashboard summary
                litTotalProducts.Text = "42";
                litLowStock.Text = "8";
                litOutOfStock.Text = "3";
                litMostSold.Text = "Pares Beef Combo";
            }
            catch (Exception ex)
            {
                // Log the error or display a message
                System.Diagnostics.Debug.WriteLine("Error loading dashboard summary: " + ex.Message);
            }
        }

        private void BindProductsGrid()
        {
            try
            {
                // Create mock product data
                DataTable dt = CreateMockProductData();

                gvProducts.DataSource = dt;
                gvProducts.DataBind();
            }
            catch (Exception ex)
            {
                // Log the error or display a message
                System.Diagnostics.Debug.WriteLine("Error binding products grid: " + ex.Message);
            }
        }

        private DataTable CreateMockProductData()
        {
            DataTable dt = new DataTable();

            // Add columns
            dt.Columns.Add("ProductID", typeof(int));
            dt.Columns.Add("SKU", typeof(string));
            dt.Columns.Add("ProductName", typeof(string));
            dt.Columns.Add("Description", typeof(string));
            dt.Columns.Add("Category", typeof(string));
            dt.Columns.Add("StockLevel", typeof(int));
            dt.Columns.Add("Price", typeof(decimal));

            // Add mock product data
            dt.Rows.Add(1, "PRS-001", "Pares Beef", "Classic Filipino beef pares with sweet sauce", "Main Dish", 25, 99.00);
            dt.Rows.Add(2, "PRS-002", "Pares Special", "Premium beef pares with extra toppings", "Main Dish", 18, 129.00);
            dt.Rows.Add(3, "PRS-003", "Beef Mami", "Hot noodle soup with beef slices", "Noodles", 12, 89.00);
            dt.Rows.Add(4, "PRS-004", "Pares Combo", "Beef pares with garlic rice and soup", "Combo Meals", 8, 149.00);
            dt.Rows.Add(5, "PRS-005", "Asado Siopao", "Steamed bun with asado filling", "Sides", 3, 45.00);
            

            return dt;
        }

        protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProducts.PageIndex = e.NewPageIndex;
            BindProductsGrid();
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Handle row commands like Edit, Delete, etc.
            if (e.CommandName == "EditProduct")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"EditProduct.aspx?id={productId}");
            }
            else if (e.CommandName == "DeleteProduct")
            {
                // For mockup, just refresh the grid without deleting anything
                BindProductsGrid();
                LoadDashboardSummary();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Just redirect to login page
            Response.Redirect("~/Pages/Accounts/Login.aspx");
        }

        // Optional: Add a search function implementation for the search bar
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(searchTerm))
            {
                SearchProducts(searchTerm);
            }
            else
            {
                // If search is empty, show all products
                BindProductsGrid();
            }
        }

        private void SearchProducts(string searchTerm)
        {
            try
            {
                // Get mock data
                DataTable dt = CreateMockProductData();

                // Filter the DataTable (case-insensitive search)
                DataTable filteredDt = dt.Clone();
                searchTerm = searchTerm.ToLower();

                foreach (DataRow row in dt.Rows)
                {
                    if (
                        row["ProductName"].ToString().ToLower().Contains(searchTerm) ||
                        row["SKU"].ToString().ToLower().Contains(searchTerm) ||
                        row["Description"].ToString().ToLower().Contains(searchTerm) ||
                        row["Category"].ToString().ToLower().Contains(searchTerm)
                    )
                    {
                        filteredDt.ImportRow(row);
                    }
                }

                gvProducts.DataSource = filteredDt;
                gvProducts.DataBind();
            }
            catch (Exception ex)
            {
                // Log the error or display a message
                System.Diagnostics.Debug.WriteLine("Error searching products: " + ex.Message);
            }
        }
    }
}