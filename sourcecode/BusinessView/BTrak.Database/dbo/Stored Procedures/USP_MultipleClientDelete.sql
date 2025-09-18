----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-25 00:00:00.000'
-- Purpose      To delete multiple clients by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC  [dbo].[USP_MultipleClientDelete] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
-- @ClientId = '<ListItems>
--  <ListRecords>
--  <ListItem>
--  <ListItemId>2FEE859D-08E1-40C3-AFC8-226F9A325113</ListItemId>
--  </ListItem>
--  <ListItem>
--  <ListItemId>7A801733-3F38-4FE7-BB4D-4875B9504AA3</ListItemId>
--  </ListItem>
--  </ListRecords>
--  </ListItems>'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_MultipleClientDelete]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@ClientId XML = NULL,
	@IsArchived BIT = 1
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)
        IF (@HavePermission = '1')
        BEGIN

		    IF(@ClientId IS NOT NULL)
			BEGIN

				CREATE TABLE #DeleteClient
				(
					Id UNIQUEIDENTIFIER
				)

				INSERT INTO #DeleteClient(Id) 

				SELECT x.value('ListItemId[1]','uniqueidentifier') AS Y		

				FROM @ClientId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)

				IF (@IsArchived = 1)
				BEGIN

				UPDATE Client SET InActiveDateTime = GETDATE(),
								  CreatedDateTime = GETDATE(),
								  CreatedByUserId = @OperationsPerformedBy
				WHERE Id IN (SELECT Id FROM #DeleteClient) AND CompanyId = @CompanyId

				UPDATE ClientSecondaryContact SET InActiveDateTime = GETDATE(),
												  CreatedDateTime = GETDATE(),
												  CreatedByUserId = @OperationsPerformedBy
				WHERE Id IN (SELECT CSC.Id FROM ClientSecondaryContact CSC JOIN #DeleteClient DC ON CSC.ClientId = DC.Id) AND CompanyId = @CompanyId

				UPDATE [User] SET IsActive = 0 WHERE Id IN (SELECT U.Id from [User] U
				INNER JOIN Client C on C.UserId = U.Id
				WHERE C.Id IN (SELECT Id FROM #DeleteClient)) AND CompanyId = @CompanyId

				UPDATE [User] SET IsActive = 0 WHERE Id IN (SELECT U.Id from [User] U
				INNER JOIN ClientSecondaryContact CSC on CSC.ClientReferenceUserId = U.Id
				INNER JOIN Client C on C.Id = CSC.ClientId
				WHERE C.Id IN (SELECT Id FROM #DeleteClient)) AND CompanyId = @CompanyId

				END
				ELSE
				BEGIN

				UPDATE Client SET InActiveDateTime = NULL,
								  CreatedDateTime = GETDATE(),
								  CreatedByUserId = @OperationsPerformedBy
				WHERE Id IN (SELECT Id FROM #DeleteClient) AND CompanyId = @CompanyId

				UPDATE ClientSecondaryContact SET InActiveDateTime = NULL,
												  CreatedDateTime = GETDATE(),
												  CreatedByUserId = @OperationsPerformedBy
				WHERE Id IN (SELECT CSC.Id FROM ClientSecondaryContact CSC JOIN #DeleteClient c ON CSC.ClientId = c.Id) AND CompanyId = @CompanyId

				UPDATE [User] SET IsActive = 1 WHERE Id IN (SELECT U.Id FROM [User] U
				INNER JOIN Client c on c.UserId = u.Id
				WHERE C.Id IN (SELECT Id FROM #DeleteClient)) AND CompanyId = @CompanyId

				UPDATE [User] SET IsActive = 1 WHERE id in (SELECT U.Id FROM [User] U
				INNER JOIN ClientSecondaryContact CSC on CSC.ClientReferenceUserId = U.Id
				INNER JOIN Client C on C.Id = CSC.ClientId
				WHERE C.Id IN (SELECT Id FROM #DeleteClient)) AND CompanyId = @CompanyId
				END 

				SELECT Id FROM #DeleteClient
            
			END		
			ELSE			
			BEGIN
			
				RAISERROR (50011,16, 1)

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
