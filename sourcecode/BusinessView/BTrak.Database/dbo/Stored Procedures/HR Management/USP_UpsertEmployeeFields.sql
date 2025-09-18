CREATE PROCEDURE [dbo].[USP_UpsertEmployeeFields]
(
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @IsHide  BIT,
   @IsRequired  BIT,
   @FieldName  NVARCHAR(250),
   @Id  UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
       
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
       
        IF (@HavePermission = '1')
        BEGIN

              IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

              DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
             
             UPDATE EmployeeFields
			 SET Hide=@IsHide,
				Mandatory=@IsRequired
				WHERE FieldName=@FieldName AND Id = @Id AND CompanyId=@CompanyId

				SELECT @ID
        END
        ELSE

            RAISERROR(@HavePermission,16,1)

     END TRY  
     BEGIN CATCH
       
           THROW
    END CATCH
END