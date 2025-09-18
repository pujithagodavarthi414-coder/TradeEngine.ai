---------------------------------------------------------------------------------------------
--EXEC USP_UpsertEmployeeBranch @EmployeeBranchId='251C6ED1-3988-42EE-B48C-4B9F7A241F21', 
--@OperationsPerformedBy= '127133F1-4427-4149-9DD6-B02E0E036971',
--@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393',@BranchId = '1210DB37-93F7-4347-9240-E978A270B707',
--@TimeStamp = 0x00000000000024A0
---------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeBranch]
(
   @EmployeeBranchId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,  
   @BranchId UNIQUEIDENTIFIER = NULL,
   @ActiveFrom DATETIME = NULL,
   @ActiveTo DATETIME = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY     
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

                  IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL   
                  
                  IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL 
                  IF(@EmployeeId IS NULL)
                  BEGIN
             
                  RAISERROR(50011,16, 2, 'Employee')
          
                  END
                  IF(@BranchId IS NULL)
                  BEGIN
             
                  RAISERROR(50011,16, 2, 'Branch')
          
                  END
                          
                  DECLARE @EmployeeBranchIdCount INT = (SELECT COUNT(1) FROM EmployeeBranch  WHERE Id = @EmployeeBranchId)
                                      
                  IF(@EmployeeBranchIdCount = 0 AND @EmployeeBranchId IS NOT NULL)
                  BEGIN
              
                    RAISERROR(50002,16, 2,'EmployeeBranch')
          
                  END
                  ELSE
                  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                  IF (@HavePermission = '1')
                  BEGIN
       
                          DECLARE @IsLatest BIT = (CASE WHEN @EmployeeBranchId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM EmployeeBranch WHERE Id = @EmployeeBranchId) = @TimeStamp THEN 1 ELSE 0 END END)
                    
                          IF(@IsLatest = 1)
                          BEGIN
                  
                            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                  
                            DECLARE @Currentdate DATETIME = GETDATE()
                        
                              IF(@EmployeeBranchId IS NULL)
						      BEGIN
						      
						        SET @EmployeeBranchId = NEWID()
						      
                                      INSERT INTO [dbo].[EmployeeBranch](
                                                  [Id],
                                                  [EmployeeId],
                                                  [BranchId],
                                                  [ActiveFrom],
                                                  [ActiveTo],
                                                  [CreatedDateTime],
                                                  [CreatedByUserId]                
                                                  )
                                           SELECT @EmployeeBranchId,
                                                  @EmployeeId,
                                                  @BranchId,
                                                  @ActiveFrom,
                                                  @ActiveTo, 
                                                  @Currentdate,
                                                  @OperationsPerformedBy  
                                    
						      END
						      ELSE
						      BEGIN
						      
						      UPDATE [dbo].[EmployeeBranch]
                                           SET    [EmployeeId] = @EmployeeId,
                                                  [BranchId] = @BranchId,
                                                  [ActiveFrom] = @ActiveFrom,
                                                  [ActiveTo] = @ActiveTo,
						  	   				      [UpdatedDateTime] = @Currentdate,
						  	   				      [UpdatedByUserId] = @OperationsPerformedBy
						  	   		WHERE Id = @EmployeeBranchId
						      
						      END
                          
                          END
                    
                          ELSE
                  
                            RAISERROR (50008,11, 1)
                  
                          END
        ELSE
        BEGIN
        
                RAISERROR (@HavePermission,11, 1)
                
        END
    END TRY
    BEGIN CATCH
        
        THROW
    END CATCH
END
GO
