CREATE PROCEDURE [dbo].[USP_CloseLead]
(
     @LeadId UNIQUEIDENTIFIER,
     @IsClosed Int,
     @OperationsPerformedBy UNIQUEIDENTIFIER
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

         DECLARE @Currentdate DATETIME = GETDATE()
         
         IF (@HavePermission = '1')
         BEGIN
         IF(@LeadId IS NOT NULL)
		 BEGIN
         DECLARE @StatusId UNIQUEIDENTIFIER
         IF(@IsClosed=1)
         BEGIN
            SET @StatusId=(SELECT Id FROM LeadStages WHERE [Name]='Lost' AND CompanyId = (Select CompanyId FROM LeadContactSubmissions WHERE Id = @LeadId))
            UPDATE [LeadContactSubmissions]
						   SET UpdatedDateTime = @Currentdate,
                               [IsClosed] = 1,
                               [statusId] = @StatusId,
                               UpdatedByUserId=@OperationsPerformedBy
							   WHERE Id = @LeadId
         END
         ELSE IF(@IsClosed=0)
         BEGIN
         SET @StatusId=(SELECT Id FROM LeadStages WHERE [Name]='Closed' AND CompanyId = (Select CompanyId FROM LeadContactSubmissions WHERE Id = @LeadId))
            UPDATE [LeadContactSubmissions]
						   SET UpdatedDateTime = @Currentdate,
                               [IsClosed] = 1,
                               [statusId] = @StatusId,
                               UpdatedByUserId=@OperationsPerformedBy
							   WHERE Id = @LeadId
         END
         ELSE
         BEGIN
            RAISERROR ('ClientCreditLimitExceeded',11, 1)
         END

            END

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