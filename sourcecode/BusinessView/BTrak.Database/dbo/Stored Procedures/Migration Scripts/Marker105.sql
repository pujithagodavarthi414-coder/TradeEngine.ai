CREATE PROCEDURE [dbo].[Marker105]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
  IF(NOT EXISTS(SELECT 1 FROM [Widget] WHERE WidgetName = 'Identification type' AND CompanyId = @CompanyId))
  BEGIN

   UPDATE [Widget] SET WidgetName = 'Identification type' WHERE WidgetName = 'License type' AND CompanyId = @CompanyId
 
  END

  UPDATE workspacedashboards SET [Name] = 'Identification type' WHERE [Name] = 'License type' AND CompanyId = @CompanyId

  UPDATE [Widget] SET [Description] = 'By using this app user can manage the Identification details of the employee. User 
  can add details like Identification number, Identification Type, Identification issue and expiry dates 
  and they can add attachments. User can also edit and delete these details. User can 
  add multiple Identification details. Users can search data from the Identification details list and 
  can sort each column.' WHERE [WidgetName] = 'Employee identification details' AND CompanyId = @CompanyId


  UPDATE [Widget] SET [Description] = 'By using this app user can see all the identification types for the company,can add identification
  type and edit the identification type.Also users can view the archived identification type 
  and can search and sort the identification type from the list.' WHERE [WidgetName] = 'Identification type' AND CompanyId = @CompanyId

 END
GO
