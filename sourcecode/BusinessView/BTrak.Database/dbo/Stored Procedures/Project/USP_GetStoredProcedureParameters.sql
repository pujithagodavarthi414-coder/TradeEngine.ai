--EXEC [dbo].[USP_GetStoredProcedureParameters] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308', @StoredProcedureName="USP_GetEmployeeProductivityOnDailyBasis"
CREATE PROCEDURE [dbo].[USP_GetStoredProcedureParameters]
(	
	@StoredProcedureName NVARCHAR(250),
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    
    SET NOCOUNT ON
    
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    BEGIN TRY
            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))));
			IF (@HavePermission = '1')
            BEGIN
			select  
				'ParameterName' = name,  
				'DataType'   = type_name(user_type_id),  
				'Length'   = max_length,  
				'Prec'   = case when type_name(system_type_id) = 'uniqueidentifier' 
				           then precision  
				           else OdbcPrec(system_type_id, max_length, precision) end,  
				'Scale'   = OdbcScale(system_type_id, scale),  
				'Param_order'  = parameter_id,  
				'Collation'   = convert(sysname, 
				                case when system_type_id in (35, 99, 167, 175, 231, 239)  
				                then ServerProperty('collation') end)  

				from sys.parameters where object_id = object_id(@StoredProcedureName);
			END
       ELSE
           RAISERROR (@HavePermission,11, 1)
    END TRY
    BEGIN CATCH
        THROW 
    END CATCH
END
GO