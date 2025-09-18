-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To get users for who the tracking is enabled
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--SELECT [dbo].[Ufn_TrackingUserList]('127133F1-4427-4149-9DD6-B02E0E036971','FC361D23-F317-4704-B86F-0D6E7287EEE9')
CREATE FUNCTION [dbo].[Ufn_TrackingUserList]
(
	@RoleId XML = NULL ,
	@BranchId XML = NULL,
	@UserId XML = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EntityId UNIQUEIDENTIFIER = NULL
)
RETURNS @UserList table
(
	UserId UNIQUEIDENTIFIER
)
BEGIN	
	
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)
		
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		
		IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
		 
		DECLARE @CanAccessAllEmployee INT = (SELECT COUNT(1) FROM Feature AS F
											JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
											JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
											JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
											WHERE F.Id = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5' AND U.Id = @OperationsPerformedBy) --View activity reports for all employee

		DECLARE @BranchIdList TABLE
		(
			BranchId UNIQUEIDENTIFIER NULL
		)

		DECLARE @RoleIdList TABLE
		(
			RoleId UNIQUEIDENTIFIER NULL
		)

		DECLARE @UserIdList TABLE
		(
			UserId UNIQUEIDENTIFIER NULL
		)

		INSERT INTO @BranchIdList VALUES( '00000000-0000-0000-0000-000000000000')
		INSERT INTO @RoleIdList VALUES( '00000000-0000-0000-0000-000000000000')
		INSERT INTO @UserIdList VALUES( '00000000-0000-0000-0000-000000000000')

		IF(@BranchId IS NOT NULL)
		BEGIN
			    DELETE FROM @BranchIdList WHERE BranchId = '00000000-0000-0000-0000-000000000000'
			    INSERT INTO @BranchIdList (BranchId)
				SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
				FROM  @BranchId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
		END
		IF(@RoleId IS NOT NULL)
		BEGIN
				DELETE FROM @RoleIdList WHERE RoleId = '00000000-0000-0000-0000-000000000000'
				INSERT INTO @RoleIdList (RoleId)
				SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
				FROM  @RoleId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
		END
		IF(@UserId IS NOT NULL)
		BEGIN
				DELETE FROM @UserIdList WHERE UserId = '00000000-0000-0000-0000-000000000000'
				INSERT INTO @UserIdList (UserId)
				SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
				FROM  @UserId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
		END

		IF(@CanAccessAllEmployee > 0)
		BEGIN
			
			INSERT INTO @UserList(UserId)
			SELECT U.Id UserId
			FROM [User] U
				INNER JOIN UserRole AS UR ON UR.UserId = U.Id AND UR.InactiveDateTime IS NULL
						   AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
						   AND U.CompanyId = @CompanyId
				INNER JOIN @RoleIdList AS RI ON UR.RoleId = RI.RoleId OR RI.RoleId = '00000000-0000-0000-0000-000000000000'
				INNER JOIN @UserIdList AS UL ON UL.UserId = U.Id OR UL.UserId = '00000000-0000-0000-0000-000000000000'
				INNER JOIN Employee AS E ON E.UserId = U.Id
				INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
							AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
							AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
							AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
				INNER JOIN @BranchIdList AS BI ON BI.BranchId = EB.BranchId OR BI.BranchId = '00000000-0000-0000-0000-000000000000'
				GROUP BY U.Id

			END
			ELSE
			BEGIN
				
				INSERT INTO @UserList(UserId)
				SELECT U.Id UserId
				FROM [User] U
				INNER JOIN UserRole AS UR ON UR.UserId = U.Id AND UR.InactiveDateTime IS NULL
						   AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
						   AND (U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy, @CompanyId)))
						   AND U.CompanyId = @CompanyId
				INNER JOIN @RoleIdList AS RI ON UR.RoleId = RI.RoleId OR RI.RoleId = '00000000-0000-0000-0000-000000000000'
				INNER JOIN @UserIdList AS UL ON UL.UserId = U.Id OR UL.UserId = '00000000-0000-0000-0000-000000000000'
				INNER JOIN Employee AS E ON E.UserId = U.Id
				INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
							AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
							AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
				INNER JOIN @BranchIdList AS BI ON BI.BranchId = EB.BranchId OR BI.BranchId = '00000000-0000-0000-0000-000000000000'
				GROUP BY U.Id
								     
          END

 RETURN
END
GO