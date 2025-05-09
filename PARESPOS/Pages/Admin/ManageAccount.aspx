<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageAccount.aspx.cs" Inherits="PARESPOS.Pages.Admin.ManageAccount" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Accounts</title>

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

        /* Button Styles */
        .add-button {
            background-color: var(--primary);
            color: white;
            font-weight: 500;
            border-radius: 8px;
            border: none;
            margin-bottom: 20px;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
        }

            .add-button:hover {
                background-color: #d25638;
                transform: translateY(-2px);
            }

        .btn {
            padding: 10px 24px;
            border-radius: 8px;
            font-weight: 500;
            font-family: 'Poppins', sans-serif;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

            .btn-primary:hover {
                background-color: #d25638;
            }

        .btn-secondary {
            background-color: #f0f0f0;
            color: #666;
        }

            .btn-secondary:hover {
                background-color: #e0e0e0;
            }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

            .btn-danger:hover {
                background-color: #c82333;
            }

        .button-container {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        /* Modal Styles */
        .modal-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-content {
            background-color: white;
            border-radius: 12px;
            width: 90%;
            max-width: 500px;
            padding: 24px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eaeaea;
        }

        .modal-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #333;
        }

        .close-button {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #666;
        }

            .close-button:hover {
                color: #333;
            }

        /* Form Styles */
        .form-group {
            margin-bottom: 18px;
        }

        .form-label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-family: 'Poppins', sans-serif;
            transition: border-color 0.2s;
        }

            .form-control:focus {
                border-color: var(--primary);
                outline: none;
            }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-col {
            flex: 1;
        }

        /* User Role Badges */
        .role-badge {
            padding: 6px 12px;
            border-radius: 9999px;
            font-weight: 500;
            font-size: 0.875rem;
            display: inline-block;
        }

        .role-admin {
            background-color: #E56441;
            color: white;
        }

        .role-cashier {
            background-color: #3498db;
            color: white;
        }

        /* Delete Modal */
        .delete-warning {
            text-align: center;
            padding: 20px 0;
        }

        .delete-icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }

        .hidden {
            display: none !important;
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
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search accounts..."
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
                    <a href="SalesReport.aspx" class="nav-item hover:bg-gray-100 text-gray-700">
                        <i class="fas fa-chart-bar"></i><span class="text-lg">Sales Report</span>
                    </a>
                    <a href="ManageAccounts.aspx" class="nav-item active text-white">
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
            <div class="max-w-full">
                <div class="flex justify-between items-center mb-8">
                    <h1 class="text-3xl font-bold text-gray-800">Manage Accounts</h1>
                    <!-- Add Account Button -->
                    <asp:Button
                        ID="btnShowAddModal"
                        runat="server"
                        Text="Add New Account"
                        CssClass="bg-[#E56441] hover:bg-[#d25638] hover:-translate-y-[2px] cursor-pointer text-white font-semibold py-2 px-4 rounded shadow-md transition duration-200"
                        OnClientClick="showAddModal(); return false;" />
                </div>

                <div class="bg-white rounded-xl custom-shadow overflow-hidden">
                    <div class="px-8 py-6 border-b border-gray-200">
                        <h2 class="text-2xl font-medium text-gray-800 font-poppins">User Accounts</h2>
                    </div>

                    <div class="overflow-x-auto">
                        <asp:GridView ID="gvAccounts" runat="server" AutoGenerateColumns="False"
                            CssClass="min-w-full divide-y divide-gray-200 font-poppins"
                            HeaderStyle-CssClass="bg-gray-50 px-8 py-4 text-left text-base font-medium text-gray-500 uppercase tracking-wider font-poppins"
                            RowStyle-CssClass="bg-white hover:bg-gray-50 font-poppins"
                            AlternatingRowStyle-CssClass="bg-gray-50 hover:bg-gray-100 font-poppins"
                            AllowPaging="true" PageSize="10" OnPageIndexChanging="gvAccounts_PageIndexChanging"
                            OnRowCommand="gvAccounts_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="UserID" HeaderText="User ID"
                                    HeaderStyle-CssClass="text-center py-5"
                                    ItemStyle-CssClass="px-8 py-5 text-center whitespace-nowrap text-base text-gray-900 font-poppins" />
                                <asp:BoundField DataField="Username" HeaderText="Username"
                                    HeaderStyle-CssClass="text-center py-5"
                                    ItemStyle-CssClass="px-8 py-5 text-center whitespace-nowrap text-base text-gray-900 font-poppins" />
                                <asp:BoundField DataField="FullName" HeaderText="Full Name"
                                    HeaderStyle-CssClass="text-center py-5"
                                    ItemStyle-CssClass="px-8 py-5 text-center whitespace-nowrap text-base text-gray-900 font-poppins" />
                                <asp:BoundField DataField="Email" HeaderText="Email"
                                    HeaderStyle-CssClass="text-center py-5"
                                    ItemStyle-CssClass="px-8 py-5 text-center whitespace-nowrap text-base text-gray-500 font-poppins" />
                                <asp:TemplateField HeaderText="Role" HeaderStyle-CssClass="text-center py-5" ItemStyle-CssClass="px-8 py-5 text-center whitespace-nowrap text-base font-poppins">
                                    <ItemTemplate>
                                        <div class="flex items-center justify-center">
                                            <%# GetRoleBadge(Eval("Role").ToString()) %>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="LastLogin" HeaderText="Last Login"
                                    DataFormatString="{0:MM/dd/yyyy hh:mm tt}"
                                    HeaderStyle-CssClass="text-center py-5"
                                    ItemStyle-CssClass="px-8 py-5 text-center whitespace-nowrap text-base text-gray-500 font-poppins" />
                                <asp:ButtonField CommandName="EditAccount" ButtonType="Button" Text="Edit"
                                    HeaderText="Actions"
                                    HeaderStyle-CssClass="text-right py-5"
                                    ItemStyle-CssClass="px-4 py-2 text-left cursor-pointer text-sm text-blue-600 font-medium font-poppins" />
                                <asp:ButtonField CommandName="DeleteAccount" ButtonType="Button" Text="Delete"
                                    ItemStyle-CssClass="px-4 py-2 text-left cursor-pointer text-sm text-red-600 font-medium font-poppins" />
                            </Columns>
                            <PagerSettings Mode="NumericFirstLast" FirstPageText="First" LastPageText="Last" Position="Bottom" />
                            <PagerTemplate>
                                <div class="bg-white border-t border-gray-200 px-8 py-4 flex items-center justify-between font-poppins">
                                    <div class="flex items-center">
                                        <span class="mr-4 text-sm text-gray-700">Page size:</span>
                                        <asp:DropDownList ID="ddlPageSize" runat="server" AutoPostBack="true"
                                            OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged"
                                            CssClass="mr-4 px-2 py-1 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-[#E56441]">
                                            <asp:ListItem Text="5" Value="5" />
                                            <asp:ListItem Text="10" Value="10" Selected="True" />
                                            <asp:ListItem Text="15" Value="15" />
                                            <asp:ListItem Text="20" Value="20" />
                                        </asp:DropDownList>
                                    </div>
                                    <div class="pagination flex items-center">
                                        <asp:LinkButton ID="lbnFirst" runat="server" CommandName="Page" CommandArgument="First"
                                            CssClass="px-3 py-1 border border-gray-300 text-sm rounded-l-md hover:bg-gray-100 font-medium"
                                            Visible='<%# ((GridView)Container.Parent.Parent).PageIndex != 0 %>'>First</asp:LinkButton>

                                        <asp:LinkButton ID="lbnPrevious" runat="server" CommandName="Page" CommandArgument="Prev"
                                            CssClass="px-3 py-1 border-t border-b border-gray-300 text-sm hover:bg-gray-100 font-medium"
                                            Visible='<%# ((GridView)Container.Parent.Parent).PageIndex != 0 %>'>Previous</asp:LinkButton>

                                        <asp:Repeater ID="rptPages" runat="server">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbnPage" runat="server" CommandName="Page" CommandArgument='<%# Container.DataItem %>'
                                                    CssClass='<%# ((GridView)Container.Parent.Parent).PageIndex == Convert.ToInt32(Container.DataItem) - 1 ? 
                                        "px-3 py-1 border-t border-b border-gray-300 bg-[#E56441] text-white text-sm" : 
                                        "px-3 py-1 border-t border-b border-gray-300 text-sm hover:bg-gray-100" %>'>
                                    <%# Container.DataItem %>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:Repeater>

                                        <asp:LinkButton ID="lbnNext" runat="server" CommandName="Page" CommandArgument="Next"
                                            CssClass="px-3 py-1 border-t border-b border-gray-300 text-sm hover:bg-gray-100 font-medium"
                                            Visible='<%# ((GridView)Container.Parent.Parent).PageIndex != ((GridView)Container.Parent.Parent).PageCount - 1 %>'>Next</asp:LinkButton>

                                        <asp:LinkButton ID="lbnLast" runat="server" CommandName="Page" CommandArgument="Last"
                                            CssClass="px-3 py-1 border border-gray-300 text-sm rounded-r-md hover:bg-gray-100 font-medium"
                                            Visible='<%# ((GridView)Container.Parent.Parent).PageIndex != ((GridView)Container.Parent.Parent).PageCount - 1 %>'>Last</asp:LinkButton>
                                    </div>
                                </div>
                            </PagerTemplate>
                        </asp:GridView>
                    </div>
                </div>

                <!-- Edit Account Modal -->
                <div id="editAccountModal" class="modal-background hidden">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h3 class="modal-title font-poppins">Edit Account</h3>
                            <button type="button" class="close-button" onclick="hideEditModal()">×</button>
                        </div>

                        <div>
                            <asp:HiddenField ID="hdnEditAccountID" runat="server" />

                            <div class="form-group">
                                <label class="form-label">Username</label>
                                <asp:TextBox ID="txtEditUsername" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Full Name</label>
                                <asp:TextBox ID="txtEditFullName" runat="server" CssClass="form-control" placeholder="Enter full name" required="required"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <asp:TextBox ID="txtEditEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter email address" required="required"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Role</label>
                                <asp:DropDownList ID="ddlEditRole" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Cashier" Value="Cashier"></asp:ListItem>
                                    <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group">
                                <label class="form-label">New Password</label>
                                <asp:TextBox ID="txtEditPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
                                <small class="text-gray-500">Leave blank to keep current password</small>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Confirm New Password</label>
                                <asp:TextBox ID="txtEditConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm new password"></asp:TextBox>
                            </div>

                            <div class="form-group mt-6 pt-4 border-t border-gray-200">
                                <label class="form-label text-red-600">Admin Password Verification</label>
                                <asp:TextBox ID="txtAdminPassword" runat="server" CssClass="form-control border-red-300" TextMode="Password" placeholder="Enter your admin password" required="required"></asp:TextBox>
                                <small class="text-gray-500">Required to confirm changes</small>
                            </div>

                            <div class="button-container">
                                <button type="button" class="btn btn-secondary" onclick="hideEditModal()">Cancel</button>
                                <asp:Button ID="btnUpdateAccount" runat="server" Text="Update Account" CssClass="btn btn-primary" OnClick="btnUpdateAccount_Click" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Add Account Modal -->
                <div id="addAccountModal" class="modal-background hidden">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h3 class="modal-title font-poppins">Add New Account</h3>
                            <button type="button" class="close-button" onclick="hideAddModal()">×</button>
                        </div>

                        <div>
                            <div class="form-group">
                                <label class="form-label">Username</label>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter username" required="required"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Full Name</label>
                                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter full name" required="required"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter email address" required="required"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Role</label>
                                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Cashier" Value="Cashier" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Password</label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter password" required="required"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Confirm Password</label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm password" required="required"></asp:TextBox>
                            </div>

                            <div class="button-container">
                                <button type="button" class="btn btn-secondary" onclick="hideAddModal()">Cancel</button>
                                <asp:Button ID="btnAddAccount" runat="server" Text="Add Account" CssClass="btn btn-primary" OnClick="btnAddAccount_Click" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Delete Account Modal -->
                <div id="deleteAccountModal" class="modal-background hidden">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h3 class="modal-title font-poppins">Confirm Deletion</h3>
                            <button type="button" class="close-button" onclick="hideDeleteModal()">×</button>
                        </div>

                        <div class="delete-warning">
                            <div class="delete-icon">🗑️</div>
                            <p>Are you sure you want to delete this account?</p>
                            <p id="accountToDelete" style="font-weight: 500; margin-top: 8px;"></p>
                        </div>

                        <asp:HiddenField ID="hdnAccountIdToDelete" runat="server" />

                        <div class="form-group mt-6 pt-4 border-t border-gray-200">
                            <label class="form-label text-red-600">Admin Password Verification</label>
                            <asp:TextBox ID="txtDeleteAdminPassword" runat="server" CssClass="form-control border-red-300" TextMode="Password" placeholder="Enter your admin password" required="required"></asp:TextBox>
                            <small class="text-gray-500">Required to confirm deletion</small>
                        </div>

                        <div class="button-container">
                            <button type="button" class="btn btn-secondary" onclick="hideDeleteModal()">Cancel</button>
                            <asp:Button ID="btnConfirmDelete" runat="server" Text="Delete" CssClass="btn btn-danger" OnClick="btnConfirmDelete_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </form>

    <script runat="server">
        protected string GetRoleBadge(string role)
        {
            if (role.ToLower() == "admin")
            {
                return "<span class='role-badge role-admin'>Admin</span>";
            }
            else
            {
                return "<span class='role-badge role-cashier'>Cashier</span>";
            }
        }
    </script>

    <script type="text/javascript">
        function showEditModal(userId, username, fullName, email, role) {
            // Set values in form
            document.getElementById('<%=hdnEditAccountID.ClientID%>').value = userId;
            document.getElementById('<%=txtEditUsername.ClientID%>').value = username;
            document.getElementById('<%=txtEditFullName.ClientID%>').value = fullName;
            document.getElementById('<%=txtEditEmail.ClientID%>').value = email;

            // Set role in dropdown
            var roleDropdown = document.getElementById('<%=ddlEditRole.ClientID%>');
            for (var i = 0; i < roleDropdown.options.length; i++) {
                if (roleDropdown.options[i].value === role) {
                    roleDropdown.selectedIndex = i;
                    break;
                }
            }

            // Clear password fields
            document.getElementById('<%=txtEditPassword.ClientID%>').value = '';
            document.getElementById('<%=txtEditConfirmPassword.ClientID%>').value = '';
            document.getElementById('<%=txtAdminPassword.ClientID%>').value = '';

            // Show modal
            document.getElementById('editAccountModal').classList.remove('hidden');
        }

        function hideEditModal() {
            document.getElementById('editAccountModal').classList.add('hidden');
        }

        function showAddModal() {
            // Clear fields
            document.getElementById('<%=txtUsername.ClientID%>').value = '';
            document.getElementById('<%=txtFullName.ClientID%>').value = '';
            document.getElementById('<%=txtEmail.ClientID%>').value = '';
            document.getElementById('<%=txtPassword.ClientID%>').value = '';
            document.getElementById('<%=txtConfirmPassword.ClientID%>').value = '';

            // Show modal
            document.getElementById('addAccountModal').classList.remove('hidden');
        }

        function hideAddModal() {
            document.getElementById('addAccountModal').classList.add('hidden');
        }

        function showDeleteModal(userId, username, fullName) {
            document.getElementById('<%=hdnAccountIdToDelete.ClientID%>').value = userId;
            document.getElementById('accountToDelete').textContent = fullName + ' (' + username + ')';
            document.getElementById('<%=txtDeleteAdminPassword.ClientID%>').value = '';
            document.getElementById('deleteAccountModal').classList.remove('hidden');
        }

        function hideDeleteModal() {
            document.getElementById('deleteAccountModal').classList.add('hidden');
        }
        // Attach click events to buttons in GridView
        window.onload = function () {
            var gridView = document.getElementById('<%=gvAccounts.ClientID%>');
            if (gridView) {
                // Set up Edit buttons
                var editButtons = gridView.querySelectorAll('input[type="button"][value="Edit"]');
                editButtons.forEach(function (button) {
                    button.onclick = function () {
                        var row = this.closest('tr');
                        var cells = row.cells;

                        var userId = cells[0].innerText.trim();
                        var username = cells[1].innerText.trim();
                        var fullName = cells[2].innerText.trim();
                        var email = cells[3].innerText.trim();
                        var role = cells[4].querySelector('.role-badge').innerText.trim();

                        showEditModal(userId, username, fullName, email, role);
                        return false;
                    };
                });

                // Set up Delete buttons
                var deleteButtons = gridView.querySelectorAll('input[type="button"][value="Delete"]');
                deleteButtons.forEach(function (button) {
                    button.onclick = function () {
                        var row = this.closest('tr');
                        var cells = row.cells;

                        var userId = cells[0].innerText.trim();
                        var username = cells[1].innerText.trim();
                        var fullName = cells[2].innerText.trim();

                        showDeleteModal(userId, username, fullName);
                        return false;
                    };
                });
            }

            // Set up mobile sidebar toggle
            document.getElementById('mobileSidebarToggle').addEventListener('click', function () {
                var sidebar = document.querySelector('aside');
                sidebar.classList.toggle('translate-x-0');
                sidebar.classList.toggle('-translate-x-full');
            });

            // Initialize mobile sidebar state
            var sidebar = document.querySelector('aside');
            if (window.innerWidth < 768) {
                sidebar.classList.add('-translate-x-full');
            }

            // Handle window resize for responsive sidebar
            window.addEventListener('resize', function () {
                if (window.innerWidth >= 768) {
                    sidebar.classList.remove('-translate-x-full');
                    sidebar.classList.add('translate-x-0');
                } else if (!sidebar.classList.contains('-translate-x-full') && !sidebar.classList.contains('translate-x-0')) {
                    sidebar.classList.add('-translate-x-full');
                }
            });
        };
    </script>
</body>
</html>

