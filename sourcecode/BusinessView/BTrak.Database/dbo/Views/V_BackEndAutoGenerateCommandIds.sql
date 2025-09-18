CREATE VIEW [dbo].[V_BackEndAutoGenerateCommandIds] AS 
SELECT 'public static Guid ' + ConstantName + 'CommandId = new Guid(' + '"' + CAST(Id AS NVARCHAR(100)) + '");'  
AS CommandId FROM [dbo].RouteConstant