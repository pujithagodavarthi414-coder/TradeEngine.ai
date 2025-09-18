-------------------------------------------------------------------------------
-- Author       Pujitharatna
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get the permission Deatails By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetPermissions] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetPermissionDetails]
(
	@UserId UNIQUEIDENTIFIER = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

     SET NOCOUNT ON

     BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	      DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
              
          IF (@HavePermission = '1')
          BEGIN

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      IF(@UserId = '00000000-0000-0000-0000-000000000000') SET  @UserId = NULL

		  IF(@DateFrom IS NULL) SET  @DateFrom = GETUTCDATE()

		  IF(@DateTo IS NULL) SET  @DateTo = GETUTCDATE()

	      SELECT U.Id ,
		         ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') AS FullName,
				 P.PermissionReasonId,
				 P.IsMorning,
				 P.IsDeleted,
				 P.Duration,
				 P.DurationInMinutes,
				 P.[Hours],
				 PR.ReasonName AS PermissionReason ,
				 P.[Date],
				 U.CompanyId, 
                 TotalCount = Count(1) OVER()
          FROM [dbo].[Permission] P WITH (NOLOCK)
               LEFT JOIN [dbo].[PermissionReason] PR ON P.PermissionReasonId = PR.Id 
			   INNER JOIN [User] U ON U.Id = P.UserId
          WHERE U.CompanyId = @CompanyId 
                AND (@UserId IS NULL OR P.UserId = @UserId)
                AND (P.[Date] >= @DateFrom AND P.[Date] <= @DateTo)
     
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