use master;
go

CREATE LOGIN Companys WITH PASSWORD = 'Company';

-- Create User for Login

use [BMCompany];
go

CREATE USER Allemployees FOR LOGIN Companys;

-- Create EmployeeBM Role
CREATE ROLE EmployeeBM;


-- Grant Permissions to EmployeeBM Role
GRANT INSERT, UPDATE, DELETE ON dbo.products TO EmployeeBM;
GRANT INSERT, UPDATE, DELETE ON dbo.customers TO EmployeeBM;
GRANT INSERT, UPDATE, DELETE ON dbo.orders TO EmployeeBM;
GRANT INSERT, UPDATE, DELETE ON dbo.orderDetails TO EmployeeBM;
GRANT INSERT, UPDATE, DELETE ON dbo.productLines TO EmployeeBM;
GRANT EXECUTE ON dbo.loginIntoAccount TO EmployeeBM;
grant execute on dbo.addNewCustomer To EmployeeBM;
grant execute on dbo.addOrder to EmployeeBM;
grant execute on dbo.addTableToProductDetails to EmployeeBM;
grant execute on dbo.CancelOrder to EmployeeBM;
grant execute on dbo.ChangePassword to EmployeeBM;
grant execute on dbo.CheckQuantity to EmployeeBM;
grant execute on dbo.deleteCustomer to EmployeeBM
grant execute on dbo.displayOrderItems to EmployeeBM;
grant execute on dbo.editOrder to EmployeeBM;
grant execute on dbo.fromRequestedToInProcess to EmployeeBM;
grant execute on dbo.payByCheck to EmployeeBM;
grant execute on dbo.removeProductsFromOrderDetails to EmployeeBM;
grant execute on dbo.shipOrder to EmployeeBM;
grant execute on dbo.sortByCountry to EmployeeBM;
grant execute on dbo.sortByOrderStatus to EmployeeBM;
grant execute on dbo.sortByProductLine to EmployeeBM;

-- Create ManagerBM Role
CREATE ROLE ManagerBM;

-- Grant Permissions to ManagerBM Role
GRANT INSERT, UPDATE, DELETE ON dbo.products TO ManagerBM;
GRANT INSERT, UPDATE, DELETE ON dbo.customers TO ManagerBM;
GRANT INSERT, UPDATE, DELETE ON dbo.orders TO ManagerBM;
GRANT INSERT, UPDATE, DELETE ON dbo.orderDetails TO ManagerBM;
GRANT INSERT, UPDATE, DELETE ON dbo.productLines TO ManagerBM;
GRANT EXECUTE ON dbo.loginIntoAccount TO ManagerBM;
grant execute on dbo.addNewCustomer To ManagerBM;
grant execute on dbo.addOrder to ManagerBM;
grant execute on dbo.addTableToProductDetails to ManagerBM;
grant execute on dbo.CancelOrder to ManagerBM;
grant execute on dbo.ChangePassword to ManagerBM;
grant execute on dbo.CheckQuantity to ManagerBM;
grant execute on dbo.deleteCustomer to ManagerBM
grant execute on dbo.displayOrderItems to ManagerBM;
grant execute on dbo.editOrder to ManagerBM;
grant execute on dbo.fromRequestedToInProcess to ManagerBM;
grant execute on dbo.payByCheck to ManagerBM;
grant execute on dbo.removeProductsFromOrderDetails to ManagerBM;
grant execute on dbo.shipOrder to ManagerBM;
grant execute on dbo.sortByCountry to ManagerBM;
grant execute on dbo.sortByOrderStatus to ManagerBM;
grant execute on dbo.UpdateProductQuantityArrival to ManagerBM;
grant execute on dbo.sortByProductLine to ManagerBM;


-- Add User to Roles
ALTER ROLE EmployeeBM ADD MEMBER AllEmployees;
ALTER ROLE ManagerBM ADD MEMBER AllEmployees;
