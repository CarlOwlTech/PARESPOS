using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PARESPOS.Pages.Admin
{
    public partial class ManageAccount : System.Web.UI.Page
    {
        // Mock data for user accounts
        private DataTable GetMockUserData()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("UserID", typeof(int));
            dt.Columns.Add("Username", typeof(string));
            dt.Columns.Add("FullName", typeof(string));
            dt.Columns.Add("Email", typeof(string));
            dt.Columns.Add("Role", typeof(string));
            dt.Columns.Add("Password", typeof(string)); // In a real app, you'd never store raw passwords
            dt.Columns.Add("LastLogin", typeof(DateTime));

            // Add mock data
            dt.Rows.Add(1, "admin", "System Administrator", "admin@parespos.com", "Admin", "admin123", DateTime.Now.AddDays(-1));
            dt.Rows.Add(2, "cashier1", "John Smith", "john.smith@parespos.com", "Cashier", "cashier123", DateTime.Now.AddDays(-2));
            dt.Rows.Add(3, "cashier2", "Maria Garcia", "maria.garcia@parespos.com", "Cashier", "cashier123", DateTime.Now.AddDays(-3));
            dt.Rows.Add(4, "manager1", "Robert Johnson", "robert.johnson@parespos.com", "Admin", "manager123", DateTime.Now.AddDays(-5));
            dt.Rows.Add(5, "cashier3", "Sarah Brown", "sarah.brown@parespos.com", "Cashier", "cashier123", DateTime.Now.AddDays(-7));
            dt.Rows.Add(6, "cashier4", "David Wilson", "david.wilson@parespos.com", "Cashier", "cashier123", DateTime.Now.AddDays(-4));
            dt.Rows.Add(7, "manager2", "Jennifer Lee", "jennifer.lee@parespos.com", "Admin", "manager123", DateTime.Now.AddDays(-2));
            dt.Rows.Add(8, "cashier5", "Michael Davis", "michael.davis@parespos.com", "Cashier", "cashier123", DateTime.Now.AddDays(-1));
            dt.Rows.Add(9, "cashier6", "Lisa Rodriguez", "lisa.rodriguez@parespos.com", "Cashier", "cashier123", DateTime.Now.AddDays(-6));
            dt.Rows.Add(10, "admin2", "Christopher Martinez", "chris.martinez@parespos.com", "Admin", "admin123", DateTime.Now.AddDays(-3));
            dt.Rows.Add(11, "cashier7", "Emily Taylor", "emily.taylor@parespos.com", "Cashier", "cashier123", DateTime.Now.AddDays(-2));
            dt.Rows.Add(12, "cashier8", "Daniel Harris", "daniel.harris@parespos.com", "Cashier", "cashier123", DateTime.Now.AddDays(-4));

            return dt;
        }

        // Store user data in session for persistency during the session
        private void SaveUserData(DataTable data)
        {
            Session["UserData"] = data;
        }

        private DataTable GetUserData()
        {
            if (Session["UserData"] == null)
            {
                DataTable initialData = GetMockUserData();
                SaveUserData(initialData);
                return initialData;
            }
            else
            {
                return (DataTable)Session["UserData"];
            }
        }

        // Helper method to search user data
        private DataTable SearchUserData(string searchTerm)
        {
            if (string.IsNullOrEmpty(searchTerm))
                return GetUserData();

            DataTable sourceData = GetUserData();
            DataTable result = sourceData.Clone();

            // Case-insensitive search across multiple columns
            foreach (DataRow row in sourceData.Rows)
            {
                if (row["Username"].ToString().ToLower().Contains(searchTerm.ToLower()) ||
                    row["FullName"].ToString().ToLower().Contains(searchTerm.ToLower()) ||
                    row["Email"].ToString().ToLower().Contains(searchTerm.ToLower()) ||
                    row["Role"].ToString().ToLower().Contains(searchTerm.ToLower()))
                {
                    result.ImportRow(row);
                }
            }

            return result;
        }

        // Page load event
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is authenticated (for a real application)
            // If not authenticated, redirect to the login page
            // if (Session["LoggedInUser"] == null)
            //     Response.Redirect("~/Login.aspx");

            if (!IsPostBack)
            {
                // Bind data to grid
                BindGridView();
            }
        }

        // Bind data to GridView
        private void BindGridView()
        {
            string searchTerm = txtSearch.Text.Trim();
            DataTable dt = SearchUserData(searchTerm);

            gvAccounts.DataSource = dt;
            gvAccounts.DataBind();

            // Set up paging
            if (gvAccounts.PageCount > 0)
            {
                ConfigurePagerControls();
            }
        }

        // Configure pager controls
        private void ConfigurePagerControls()
        {
            if (gvAccounts.FooterRow != null)
            {
                Repeater rptPages = (Repeater)gvAccounts.FooterRow.FindControl("rptPages");
                if (rptPages != null)
                {
                    List<int> pageNumbers = new List<int>();
                    int startPageNumber = Math.Max(1, gvAccounts.PageIndex - 2);
                    int endPageNumber = Math.Min(gvAccounts.PageCount, gvAccounts.PageIndex + 3);

                    for (int i = startPageNumber; i <= endPageNumber; i++)
                    {
                        pageNumbers.Add(i);
                    }

                    rptPages.DataSource = pageNumbers;
                    rptPages.DataBind();
                }
            }
        }

        // GridView page index changing event
        protected void gvAccounts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvAccounts.PageIndex = e.NewPageIndex;
            BindGridView();
        }

        // GridView row command event
        protected void gvAccounts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditAccount" || e.CommandName == "DeleteAccount")
            {
                // Not necessary for JavaScript-based action handling as we're using client-side script
                // This would be used if we wanted server-side handling
            }
        }

        // Page size selection changed event
        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlPageSize = (DropDownList)sender;
            gvAccounts.PageSize = Convert.ToInt32(ddlPageSize.SelectedValue);
            gvAccounts.PageIndex = 0; // Reset to first page
            BindGridView();
        }

        // Add account button click event
        protected void btnAddAccount_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate input
                if (string.IsNullOrEmpty(txtUsername.Text) ||
                    string.IsNullOrEmpty(txtFullName.Text) ||
                    string.IsNullOrEmpty(txtEmail.Text) ||
                    string.IsNullOrEmpty(txtPassword.Text) ||
                    string.IsNullOrEmpty(txtConfirmPassword.Text))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                        "alert('All fields are required.');", true);
                    return;
                }

                // Check if passwords match
                if (txtPassword.Text != txtConfirmPassword.Text)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                        "alert('Passwords do not match.');", true);
                    return;
                }

                // Check if username already exists
                DataTable dt = GetUserData();
                bool usernameExists = false;

                foreach (DataRow row in dt.Rows)
                {
                    if (row["Username"].ToString().Equals(txtUsername.Text, StringComparison.OrdinalIgnoreCase))
                    {
                        usernameExists = true;
                        break;
                    }
                }

                if (usernameExists)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                        "alert('Username already exists. Please choose a different username.');", true);
                    return;
                }

                // Add new user
                int newUserId = dt.Rows.Count > 0 ?
                    Convert.ToInt32(dt.Compute("MAX(UserID)", string.Empty)) + 1 : 1;

                DataRow newRow = dt.NewRow();
                newRow["UserID"] = newUserId;
                newRow["Username"] = txtUsername.Text;
                newRow["FullName"] = txtFullName.Text;
                newRow["Email"] = txtEmail.Text;
                newRow["Role"] = ddlRole.SelectedValue;
                newRow["Password"] = txtPassword.Text; // In real app, hash this password
                newRow["LastLogin"] = DateTime.Now;

                dt.Rows.Add(newRow);
                SaveUserData(dt);

                // Rebind grid and show success message
                BindGridView();
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Account created successfully.'); hideAddModal();", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    $"alert('Error creating account: {ex.Message}');", true);
            }
        }

        // Update account button click event
        protected void btnUpdateAccount_Click(object sender, EventArgs e)
        {
            try
            {
                int userIdToEdit = Convert.ToInt32(hdnEditAccountID.Value);

                // Verify admin password (in real app, check against database)
                // For demo, we'll use a simple check
                if (txtAdminPassword.Text != "admin123")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                        "alert('Invalid admin password.');", true);
                    return;
                }

                // If changing password, validate it matches confirmation
                if (!string.IsNullOrEmpty(txtEditPassword.Text))
                {
                    if (txtEditPassword.Text != txtEditConfirmPassword.Text)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                            "alert('New passwords do not match.');", true);
                        return;
                    }
                }

                // Update user data
                DataTable dt = GetUserData();

                foreach (DataRow row in dt.Rows)
                {
                    if (Convert.ToInt32(row["UserID"]) == userIdToEdit)
                    {
                        row["FullName"] = txtEditFullName.Text;
                        row["Email"] = txtEditEmail.Text;
                        row["Role"] = ddlEditRole.SelectedValue;

                        // Update password if provided
                        if (!string.IsNullOrEmpty(txtEditPassword.Text))
                        {
                            row["Password"] = txtEditPassword.Text; // In real app, hash this password
                        }

                        break;
                    }
                }

                SaveUserData(dt);

                // Rebind grid and show success message
                BindGridView();
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Account updated successfully.'); hideEditModal();", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    $"alert('Error updating account: {ex.Message}');", true);
            }
        }

        // Delete account button click event
        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            try
            {
                int userIdToDelete = Convert.ToInt32(hdnAccountIdToDelete.Value);

                // Verify admin password (in real app, check against database)
                // For demo, we'll use a simple check
                if (txtDeleteAdminPassword.Text != "admin123")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                        "alert('Invalid admin password.');", true);
                    return;
                }

                // Delete user from data
                DataTable dt = GetUserData();
                DataRow rowToDelete = null;

                foreach (DataRow row in dt.Rows)
                {
                    if (Convert.ToInt32(row["UserID"]) == userIdToDelete)
                    {
                        rowToDelete = row;
                        break;
                    }
                }

                if (rowToDelete != null)
                {
                    dt.Rows.Remove(rowToDelete);
                    SaveUserData(dt);
                }

                // Rebind grid and show success message
                BindGridView();
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Account deleted successfully.'); hideDeleteModal();", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    $"alert('Error deleting account: {ex.Message}');", true);
            }
        }

        // Logout button click event
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // In a real application:
            // Session.Clear();
            // Session.Abandon();
            Response.Redirect("~/Pages/Accounts/Login.aspx");
        }
    }
}