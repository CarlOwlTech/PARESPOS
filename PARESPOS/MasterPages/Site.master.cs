using System;
using System.Web.UI;

namespace PARESPOS
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Pages/Accounts/Login.aspx");
            }

            // Display username
            litUserName.Text = Session["UserName"]?.ToString() ?? "User";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear session
            Session.Clear();
            Session.Abandon();

            // Redirect to login page
            Response.Redirect("~/Pages/Accounts/Login.aspx");
        }
    }
}