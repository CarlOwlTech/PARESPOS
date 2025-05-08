using System;
using System.Web.UI;

namespace PARESPOS.Pages.Accounts
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is already logged in
            if (Session["UserID"] != null)
            {
                // Redirect based on user role
                if (Session["UserRole"].ToString() == "Admin")
                {
                    Response.Redirect("~/Pages/Admin/Dashboard.aspx");
                }
                else
                {
                    Response.Redirect("~/Pages/User/Dashboard.aspx");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // For demonstration purposes - replace with actual authentication logic
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            // Simple validation
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblErrorMessage.Text = "Username and password are required";
                lblErrorMessage.Visible = true;
                return;
            }

            // In a real application, verify credentials against your database
            // For demo, we'll use hardcoded values
            if (username == "admin" && password == "admin123")
            {
                Session["UserID"] = "1";
                Session["UserName"] = "Admin User";
                Session["UserRole"] = "Admin";
                Response.Redirect("~/Pages/Admin/Dashboard.aspx");
            }
            else if (username == "cashier" && password == "cashier123")
            {
                Session["UserID"] = "2";
                Session["UserName"] = "Cashier";
                Session["UserRole"] = "Cashier";
                Response.Redirect("~/Pages/User/Dashboard.aspx");
            }
            else
            {
                lblErrorMessage.Text = "Invalid username or password";
                lblErrorMessage.Visible = true;
            }
        }

        protected void lnkForgotPassword_Click(object sender, EventArgs e)
        {
            // Implement password recovery logic or redirect to password recovery page
            Response.Redirect("~/Pages/Accounts/ForgotPassword.aspx");
        }
    }
}