using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PARESPOS.Pages.Admin
{
    public partial class Products : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsUserAuthenticated())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindProductsGrid();
            }
        }

        private bool IsUserAuthenticated()
        {
            // TODO: Replace with real session check in production
            return true;
        }

        private void BindProductsGrid()
        {
            try
            {
                gvProducts.DataSource = CreateMockProductData();
                gvProducts.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error binding product grid: " + ex.Message);
            }
        }

        private DataTable CreateMockProductData()
        {
            DataTable dt = new DataTable();

            dt.Columns.Add("ProductID", typeof(int));
            dt.Columns.Add("SKU", typeof(string));
            dt.Columns.Add("ProductName", typeof(string));
            dt.Columns.Add("Description", typeof(string));
            dt.Columns.Add("Category", typeof(string));
            dt.Columns.Add("StockLevel", typeof(int));
            dt.Columns.Add("Price", typeof(decimal));

            dt.Rows.Add(1, "PRS-001", "Pares Beef", "Classic Filipino beef pares with sweet sauce", "Main Dish", 25, 99.00m);
            dt.Rows.Add(2, "PRS-002", "Pares Special", "Premium beef pares with extra toppings", "Main Dish", 18, 129.00m);
            dt.Rows.Add(3, "PRS-003", "Beef Mami", "Hot noodle soup with beef slices", "Noodles", 12, 89.00m);
            dt.Rows.Add(4, "PRS-004", "Pares Combo", "Beef pares with garlic rice and soup", "Combo Meals", 8, 149.00m);
            dt.Rows.Add(5, "PRS-005", "Asado Siopao", "Steamed bun with asado filling", "Sides", 3, 45.00m);
            dt.Rows.Add(6, "PRS-006", "Rice", "Plain steamed rice", "Sides", 50, 20.00m);
            dt.Rows.Add(7, "PRS-007", "Garlic Rice", "Fried rice with garlic", "Sides", 35, 35.00m);
            dt.Rows.Add(8, "PRS-008", "Pares Mami", "Beef pares with noodle soup", "Noodles", 0, 119.00m);
            dt.Rows.Add(9, "PRS-009", "Pares Lomi", "Thick noodle soup with beef pares", "Noodles", 15, 129.00m);
            dt.Rows.Add(10, "PRS-010", "Beef Wonton", "Beef dumplings in soup", "Sides", 0, 75.00m);
            dt.Rows.Add(11, "PRS-011", "Iced Tea", "House special iced tea", "Beverages", 42, 35.00m);
            dt.Rows.Add(12, "PRS-012", "Soda", "Assorted soda drinks", "Beverages", 28, 40.00m);

            return dt;
        }

        protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProducts.PageIndex = e.NewPageIndex;
            BindProductsGrid();
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditProduct")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gvProducts.Rows[rowIndex];
                string sku = row.Cells[0].Text; // Assuming SKU is in the first cell
                Response.Redirect($"EditProduct.aspx?sku={sku}");
            }
            else if (e.CommandName == "DeleteProduct")
            {
                // This is handled via client-side JavaScript
                // The actual deletion happens in btnConfirmDelete_Click
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Just redirect to login page
            Response.Redirect("~/Pages/Accounts/Login.aspx");
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(searchTerm))
            {
                SearchProducts(searchTerm);
            }
            else
            {
                BindProductsGrid();
            }
        }

        private void SearchProducts(string searchTerm)
        {
            try
            {
                DataTable dt = CreateMockProductData();
                DataTable filteredDt = dt.Clone();
                searchTerm = searchTerm.ToLower();

                foreach (DataRow row in dt.Rows)
                {
                    if (row["ProductName"].ToString().ToLower().Contains(searchTerm) ||
                        row["SKU"].ToString().ToLower().Contains(searchTerm) ||
                        row["Description"].ToString().ToLower().Contains(searchTerm) ||
                        row["Category"].ToString().ToLower().Contains(searchTerm))
                    {
                        filteredDt.ImportRow(row);
                    }
                }

                gvProducts.DataSource = filteredDt;
                gvProducts.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error searching products: " + ex.Message);
            }
        }

        // Add Product handler
        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            try
            {
                // Get values from form
                string sku = txtSKU.Text.Trim();
                string productName = txtProductName.Text.Trim();
                string description = txtDescription.Text.Trim();
                string category = ddlCategory.SelectedValue;
                int stockLevel = Convert.ToInt32(txtStockLevel.Text.Trim());
                decimal price = Convert.ToDecimal(txtPrice.Text.Trim());

                // In a real application, you would save to database here
                // For this mock version, we'll just add to our DataTable and rebind

                // Clear form fields
                txtSKU.Text = string.Empty;
                txtProductName.Text = string.Empty;
                txtDescription.Text = string.Empty;
                ddlCategory.SelectedIndex = 0;
                txtStockLevel.Text = string.Empty;
                txtPrice.Text = string.Empty;

                // Refresh the grid
                BindProductsGrid();

                // Add client-side script to hide modal after submission
                ScriptManager.RegisterStartupScript(this, GetType(),
                    "hideAddModal", "hideAddModal();", true);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error adding product: " + ex.Message);
                // In a real application, you would show an error message to the user
            }
        }

        // Edit method
        protected void btnUpdateProduct_Click(object sender, EventArgs e)
        {
            try
            {
                // Get values from form
                string sku = hdnEditProductSKU.Value;
                string productName = txtEditProductName.Text.Trim();
                string description = txtEditDescription.Text.Trim();
                string category = ddlEditCategory.SelectedValue;
                int stockLevel = Convert.ToInt32(txtEditStockLevel.Text.Trim());
                decimal price = Convert.ToDecimal(txtEditPrice.Text.Trim());

                // In a real application, you would update the database here
                // For this mock version, we'll just rebind the grid

                // Clear form fields
                hdnEditProductSKU.Value = string.Empty;
                txtEditSKU.Text = string.Empty;
                txtEditProductName.Text = string.Empty;
                txtEditDescription.Text = string.Empty;
                ddlEditCategory.SelectedIndex = 0;
                txtEditStockLevel.Text = string.Empty;
                txtEditPrice.Text = string.Empty;

                // Refresh the grid
                BindProductsGrid();

                // Add client-side script to hide modal after submission
                ScriptManager.RegisterStartupScript(this, GetType(),
                    "hideEditModal", "hideEditModal();", true);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error updating product: " + ex.Message);
                // In a real application, you would show an error message to the user
            }
        }

        // Confirm delete method
        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            try
            {
                // Get the product ID from hidden field
                string productIdToDelete = hdnProductIdToDelete.Value;

                // In a real application, you would delete from database here
                // For this mock version, we'll just rebind the grid

                // Refresh the grid
                BindProductsGrid();

                // Add client-side script to hide modal after deletion
                ScriptManager.RegisterStartupScript(this, GetType(),
                    "hideDeleteModal", "hideDeleteModal();", true);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error deleting product: " + ex.Message);
                // In a real application, you would show an error message to the user
            }
        }

        // Add the missing method for page size change
        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                // Get selected page size
                DropDownList ddlPageSize = (DropDownList)sender;
                gvProducts.PageSize = Convert.ToInt32(ddlPageSize.SelectedValue);

                // Reset to first page when changing page size
                gvProducts.PageIndex = 0;

                // Rebind the grid with new page size
                BindProductsGrid();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error changing page size: " + ex.Message);
            }
        }
    }
}