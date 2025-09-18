-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSharedorUnsharedchannels] @OperationsPerformedBy='C2AF5BB2-42A1-4D07-99B2-2A93C0A3422F', @UserId='953B07E9-A6D0-4B7C-B1E7-61FF309B9BF4',@IsShared=null
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetSharedorUnsharedchannels]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  --@IsArchived BIT = NULL,
  @IsShared BIT = NULL,
  @UserId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
           DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
          
          IF (@HavePermission = '1')
          BEGIN
              IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
              IF (@UserId='00000000-0000-0000-0000-000000000000') SET @UserId = NULL
              
              DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
              
              
              IF(@IsShared=1 OR @IsShared IS NULL)
			  BEGIN

              SELECT C.CompanyId,
                     C.ChannelName,
                     --(CASE WHEN C.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsDeleted,
                     C.[TimeStamp],
                     C.Id,
                     c.CreatedByUserId
					,c.CreatedDateTime
					,c.CurrentOwnerShipId
                     FROM  [Channel] C
                             INNER JOIN [ChannelMember] CM ON CM.ChannelId = C.Id AND CM.MemberUserId = @OperationsPerformedBy   AND CM.InActiveDateTime IS NULL AND CM.ActiveTo IS NULL
                             INNER JOIN [ChannelMember] CMM ON CMM.ChannelId = C.Id AND CMM.MemberUserId = @UserId AND CMM.InActiveDateTime IS NULL AND CMM.ActiveTo IS NULL
							 
                    WHERE  (C.CompanyId = @CompanyId)
					AND C.InActiveDateTime IS NULL
					--AND (@IsArchived IS NULL 
     --                          OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) 
     --                          OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL)) 
						END
						ELSE
						BEGIN
						
					SELECT C.CompanyId,
                     C.ChannelName,
                     --(CASE WHEN C.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsDeleted,
                     C.[TimeStamp],
                     C.Id,
                     c.CreatedByUserId
					,c.CreatedDateTime
					,c.CurrentOwnerShipId
                     FROM  [Channel] C
                             INNER JOIN [ChannelMember] CM ON CM.ChannelId = C.Id AND CM.MemberUserId = @UserId AND CM.InActiveDateTime IS NULL AND CM.ActiveTo IS NULL
                           
                    WHERE  (C.CompanyId = @CompanyId)
					AND C.Id NOT IN (SELECT C.Id FROM Channel  C
					INNER JOIN ChannelMember CM ON CM.ChannelId=C.Id WHERE CM.MemberUserId=@OperationsPerformedBy AND CM.InActiveDateTime IS NULL AND CM.ActiveTo IS NULL)
					AND C.InActiveDateTime IS NULL
					--AND (@IsArchived IS NULL 
     --                          OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) 
     --                          OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL)) 

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