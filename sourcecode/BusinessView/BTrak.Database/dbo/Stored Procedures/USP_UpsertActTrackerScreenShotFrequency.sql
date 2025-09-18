--EXEC [dbo].[USP_UpsertActTrackerScreenShotFrequency] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@ScreenShotFrequency=21
--@RoleIdXMl='<?xml version="1.0" encoding="utf-8"?>
--<GenericListOfNullableOfGuid
-- xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
--  xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <ListItems><guid>606e7152-047c-43ba-8426-03a743bbaef4</guid>
--          <guid>381d7c81-1274-4c77-970b-142a82bf6e2b</guid>
--          <guid>90d51fd0-f599-4b89-ad20-31a74f1a93ea</guid>
--          <guid>4d5adf0f-88df-462c-a987-38ac05aeab0c</guid>
--          <guid>511bbedd-5c23-49fd-af05-2e82061426df</guid></ListItems></GenericListOfNullableOfGuid>'--
CREATE PROCEDURE [dbo].[USP_UpsertActTrackerScreenShotFrequency](
@RoleIdXMl XMl ,
@UserIdXML XML = NULL,
@ScreenShotFrequency INT = NULL,
@Multiplier INT = NULL,
@FrequencyIndex INT = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@Remove BIT = NULL,
@IsSelectAll BIT = NULL,
@IsUserSelectAll BIT = NULL,
@IsRandomScreenshot BIT = NULL,
@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
     SET NOCOUNT ON
       BEGIN TRY
            IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
            BEGIN
               DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                 IF (@HavePermission = '1')
                 BEGIN
                        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                        DECLARE @Currentdate DATETIME = GETDATE()

						DECLARE @OldScreenShotFrequency INT = NULL
						DECLARE @OldMultiplier INT = NULL
						DECLARE @OldIsRandomScreenshot BIT = NULL
						DECLARE @OldValue INT = NULL
						DECLARE @NewValue INT = NULL
						DECLARE @OldRandomScreenShot NVARCHAR(20)
						DECLARE @NewRandomScreenShot NVARCHAR(20)

						SELECT @OldIsRandomScreenshot = RandomScreenshot,
							   @OldScreenShotFrequency = ScreenShotFrequency,
							   @OldMultiplier = Multiplier
							   FROM ActivityTrackerScreenShotFrequency WHERE ComapnyId = @CompanyId

						IF(@Remove IS NULL OR @Remove = 0)
						BEGIN
							CREATE TABLE #RoleIds ( Id UNIQUEIDENTIFIER,
											RoleId UNIQUEIDENTIFIER,
											IsExist BIT
											)

							CREATE TABLE #UserIds ( Id UNIQUEIDENTIFIER,
											UserId UNIQUEIDENTIFIER,
											IsExist BIT
											)
                
							INSERT INTO #RoleIds(Id,RoleId)
							SELECT NEWID(),
									x.y.value('(text())[1]','UNIQUEIDENTIFIER')
									FROM
									@RoleIdXMl.nodes('/GenericListOfNullableOfGuid
																/ListItems/guid')AS x(y)

							IF(@UserIdXML IS NOT NULL)
							BEGIN
								
								INSERT INTO #UserIds(Id, UserId)
								SELECT NEWID(),
										x.y.value('(text())[1]','UNIQUEIDENTIFIER')                          
										FROM  
										@UserIdXMl.nodes('/GenericListOfNullableOfGuid
																/ListItems/guid')AS x(y)

							END

							IF(@FrequencyIndex = -2)
							BEGIN

								UPDATE ActivityTrackerScreenShotFrequency SET ScreenShotFrequency = @ScreenShotFrequency, RandomScreenshot = @IsRandomScreenshot WHERE ComapnyId = @CompanyId

							END
							ELSE
							BEGIN
								
								UPDATE ActivityTrackerScreenShotFrequency SET ScreenShotFrequency = @ScreenShotFrequency, Multiplier = @Multiplier, FrequencyIndex = -1, SelectAll = 0, RandomScreenshot = @IsRandomScreenshot
								WHERE FrequencyIndex = @FrequencyIndex AND ComapnyId = @CompanyId

								UPDATE ActivityTrackerScreenShotFrequency SET ScreenShotFrequency = @ScreenShotFrequency, Multiplier = @Multiplier, FrequencyIndex = @FrequencyIndex, SelectAll = @IsSelectAll, RandomScreenshot = @IsRandomScreenshot
								WHERE RoleId IN (SELECT RoleId FROM #RoleIds) AND ComapnyId = @CompanyId
								
								UPDATE #RoleIds SET IsExist = CASE WHEN A.RoleId = RI.RoleId AND A.ScreenShotFrequency = @ScreenShotFrequency AND RandomScreenshot = @IsRandomScreenshot AND @Multiplier = A.Multiplier AND @FrequencyIndex = A.FrequencyIndex THEN 1 ELSE 0 END 
								FROM [ActivityTrackerScreenShotFrequency] A 
										JOIN #RoleIds RI ON RI.RoleId=A.RoleId AND @ScreenShotFrequency = A.ScreenShotFrequency AND A.InActiveDateTime IS NULL

								UPDATE ActivityTrackerScreenShotFrequency SET FrequencyIndex = @FrequencyIndex, SelectAll = 0, RandomScreenshot = @IsRandomScreenshot WHERE ComapnyId = @CompanyId AND @FrequencyIndex = -1

								UPDATE ActivityTrackerScreenShotFrequency SET ScreenShotFrequency = @ScreenShotFrequency, RandomScreenshot = @IsRandomScreenshot WHERE ComapnyId = @CompanyId

								UPDATE ActivityTrackerScreenShotFrequency SET RandomScreenshot = @IsRandomScreenshot WHERE ComapnyId = @CompanyId

								IF(@UserIdXML IS NOT NULL)
								BEGIN
									UPDATE ActivityTrackerScreenShotFrequencyUser SET InActiveDateTime = GETDATE(), FrequencyIndex = -1 WHERE FrequencyIndex = @FrequencyIndex
								
									UPDATE ActivityTrackerScreenShotFrequencyUser SET ScreenShotFrequency = @ScreenShotFrequency, Multiplier = @Multiplier, FrequencyIndex = @FrequencyIndex, SelectAll = @IsUserSelectAll, InActiveDateTime = NULL
									WHERE UserId IN (SELECT UserId FROM #UserIds) AND ComapnyId = @CompanyId
									
									UPDATE #UserIds SET IsExist = CASE WHEN A.UserId = RI.UserId AND A.ScreenShotFrequency = @ScreenShotFrequency AND @Multiplier = A.Multiplier AND @FrequencyIndex = A.FrequencyIndex THEN 1 ELSE 0 END 
									FROM [ActivityTrackerScreenShotFrequencyUser] A 
											JOIN #UserIds RI ON RI.UserId=A.UserId AND @ScreenShotFrequency = A.ScreenShotFrequency AND A.InActiveDateTime IS NULL

									UPDATE ActivityTrackerScreenShotFrequencyUser SET FrequencyIndex = @FrequencyIndex, SelectAll = 0, InActiveDateTime = NULL WHERE ComapnyId = @CompanyId AND @FrequencyIndex = -1

									UPDATE ActivityTrackerScreenShotFrequencyUser SET ScreenShotFrequency = @ScreenShotFrequency, InActiveDateTime = NULL WHERE ComapnyId = @CompanyId

								END
								IF(@UserIdXML IS NULL)
								BEGIN
									UPDATE ActivityTrackerScreenShotFrequencyUser SET ScreenShotFrequency = @ScreenShotFrequency, Multiplier = @Multiplier, FrequencyIndex = -1, SelectAll = 0, InActiveDateTime = GETDATE() WHERE @FrequencyIndex = -1 AND ComapnyId = @CompanyId

									UPDATE ActivityTrackerScreenShotFrequencyUser SET ScreenShotFrequency = @ScreenShotFrequency, Multiplier = @Multiplier, FrequencyIndex = -1, SelectAll = 0, InActiveDateTime = GETDATE() WHERE FrequencyIndex = @FrequencyIndex AND ComapnyId = @CompanyId
								END

							END
								INSERT INTO [dbo].[ActivityTrackerScreenShotFrequency](
																				Id,
																				ScreenShotFrequency,
																			  RoleId,
																			  ComapnyId,
																			  Multiplier,
																			  FrequencyIndex,
																			  SelectAll,
																			  RandomScreenshot,
																			  CreatedDateTime,
																			  CreatedByUserId
																			  )
																		SELECT Id,
																			   @ScreenShotFrequency,
																			   RoleId,
																			   @CompanyId,
																			   @Multiplier,
																			   IIF(@FrequencyIndex = -2, -1, @FrequencyIndex),
																			   @IsSelectAll,
																			   @IsRandomScreenshot,
																			   @Currentdate,
                                                                           @OperationsPerformedBy
                                                                          FROM #RoleIds WHERE (IsExist IS NULL OR IsExist = 0)
                                                                          --WHERE RoleId NOT IN (SELECT RoleId FROM [ActTrackerScreenShotFrequency] WHERE InActiveDateTime IS NULL)
                                                
								INSERT INTO [dbo].[ActivityTrackerScreenShotFrequencyUser](
																				Id,
																				ScreenShotFrequency,
																				UserId,
																				ComapnyId,
																				Multiplier,
																				FrequencyIndex,
																				SelectAll,
																				CreatedDateTime,
																				CreatedByUserId
																			  )
																		SELECT Id,                                                                     
																			   @ScreenShotFrequency,
																			   UserId,
																			   @CompanyId,
																			   @Multiplier,
																			   IIF(@FrequencyIndex = -2, -1, @FrequencyIndex),
																			   @IsUserSelectAll,
																			   @Currentdate,
                                                                           @OperationsPerformedBy
                                                                          FROM #UserIds WHERE (IsExist IS NULL OR IsExist = 0)
                                                    SELECT RoleId FROM #RoleIds

								UPDATE ActivityTrackerScreenShotFrequency SET RandomScreenshot = @IsRandomScreenshot WHERE ComapnyId = @CompanyId
						END
						ELSE
						BEGIN

							DECLARE @Index INT = IIF((SELECT COUNT(*) FROM ActivityTrackerScreenShotFrequency WHERE FrequencyIndex = -1 AND ComapnyId = @CompanyId) > 0, -1 , @FrequencyIndex)
							DECLARE @Multi INT = (SELECT TOP(1) Multiplier FROM ActivityTrackerScreenShotFrequency WHERE FrequencyIndex = @Index AND ComapnyId = @CompanyId)
							UPDATE ActivityTrackerScreenShotFrequency SET ScreenShotFrequency = @ScreenShotFrequency, Multiplier = @Multi, FrequencyIndex = -1, SelectAll = 0, RandomScreenshot = @IsRandomScreenshot 
									WHERE FrequencyIndex = @FrequencyIndex AND ComapnyId = @CompanyId
							UPDATE ActivityTrackerScreenShotFrequency SET ScreenShotFrequency = @ScreenShotFrequency, RandomScreenshot = @IsRandomScreenshot WHERE ComapnyId = @CompanyId
							UPDATE ActivityTrackerScreenShotFrequency SET FrequencyIndex = @FrequencyIndex, RandomScreenshot = @IsRandomScreenshot WHERE FrequencyIndex > @FrequencyIndex AND ComapnyId = @CompanyId
							UPDATE ActivityTrackerScreenShotFrequency SET RandomScreenshot = @IsRandomScreenshot WHERE ComapnyId = @CompanyId

							IF(@UserIdXML IS NOT NULL)
							BEGIN

								SET @Index = IIF((SELECT COUNT(*) FROM ActivityTrackerScreenShotFrequencyUser WHERE FrequencyIndex = -1 AND ComapnyId = @CompanyId) > 0, -1 , @FrequencyIndex)

								SET @Multi = (SELECT TOP(1) Multiplier FROM ActivityTrackerScreenShotFrequencyUser WHERE FrequencyIndex = @Index AND ComapnyId = @CompanyId)

								UPDATE ActivityTrackerScreenShotFrequencyUser SET ScreenShotFrequency = @ScreenShotFrequency, Multiplier = @Multi, FrequencyIndex = -1, SelectAll = 0, InActiveDateTime = GETDATE() WHERE FrequencyIndex = @FrequencyIndex AND ComapnyId = @CompanyId

								UPDATE ActivityTrackerScreenShotFrequencyUser SET ScreenShotFrequency = @ScreenShotFrequency WHERE ComapnyId = @CompanyId

								UPDATE ActivityTrackerScreenShotFrequencyUser SET FrequencyIndex = @FrequencyIndex WHERE FrequencyIndex > @FrequencyIndex AND ComapnyId = @CompanyId

							END
							IF(@UserIdXML IS NULL)
							BEGIN
								UPDATE ActivityTrackerScreenShotFrequencyUser SET ScreenShotFrequency = @ScreenShotFrequency, Multiplier = @Multi, FrequencyIndex = -1, SelectAll = 0, InActiveDateTime = GETDATE() WHERE FrequencyIndex = @FrequencyIndex AND ComapnyId = @CompanyId
							END

						END
						    SET @OldValue = @OldScreenShotFrequency 
							SET @NewValue = @ScreenShotFrequency
				    
							IF(@OldValue <> @NewValue)
							EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Screenshot frequency',
							@FieldName = 'ScreenShotFrequency',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

							SET @OldValue = @OldMultiplier
							SET @NewValue = @Multiplier
				    
							IF(@OldValue <> @NewValue)
							EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Screenshot frequency',
							@FieldName = 'Multiplier',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

							SET @OldRandomScreenShot = IIF(@OldIsRandomScreenshot = 0,'Disabled','Enabled')
							SET @NewRandomScreenShot = IIF(@IsRandomScreenshot = 0,'Disabled','Enabled')
				    
							IF(@OldRandomScreenShot <> @NewRandomScreenShot)
							EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Screenshot frequency',
							@FieldName = 'RandomScreenshot',@OldValue = @OldRandomScreenShot,@NewValue = @NewRandomScreenShot, @CompanyId = @CompanyId
                   END
                   ELSE
                   BEGIN
                        RAISERROR (@HavePermission,11, 1)
                    END
                END
              END TRY
    BEGIN CATCH
        THROW
    END CATCH
END