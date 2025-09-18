using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the User table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserDbEntity aUser)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUser.Id);
					 vParams.Add("@CompanyId",aUser.CompanyId);
					 vParams.Add("@SurName",aUser.SurName);
					 vParams.Add("@FirstName",aUser.FirstName);
					 vParams.Add("@UserName",aUser.UserName);
					 vParams.Add("@Password",aUser.Password);
					 vParams.Add("@RoleId",aUser.RoleId);
					 vParams.Add("@IsPasswordForceReset",aUser.IsPasswordForceReset);
					 vParams.Add("@IsActive",aUser.IsActive);
					 vParams.Add("@TimeZoneId",aUser.TimeZoneId);
					 vParams.Add("@MobileNo",aUser.MobileNo);
					 vParams.Add("@IsAdmin",aUser.IsAdmin);
					 vParams.Add("@IsActiveOnMobile",aUser.IsActiveOnMobile);
					 vParams.Add("@ProfileImage",aUser.ProfileImage);
					 vParams.Add("@RegisteredDateTime",aUser.RegisteredDateTime);
					 vParams.Add("@LastConnection",aUser.LastConnection);
					 vParams.Add("@CreatedDateTime",aUser.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUser.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUser.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUser.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the User table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserDbEntity aUser)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUser.Id);
					 vParams.Add("@CompanyId",aUser.CompanyId);
					 vParams.Add("@SurName",aUser.SurName);
					 vParams.Add("@FirstName",aUser.FirstName);
					 vParams.Add("@UserName",aUser.UserName);
					 vParams.Add("@Password",aUser.Password);
					 vParams.Add("@RoleId",aUser.RoleId);
					 vParams.Add("@IsPasswordForceReset",aUser.IsPasswordForceReset);
					 vParams.Add("@IsActive",aUser.IsActive);
					 vParams.Add("@TimeZoneId",aUser.TimeZoneId);
					 vParams.Add("@MobileNo",aUser.MobileNo);
					 vParams.Add("@IsAdmin",aUser.IsAdmin);
					 vParams.Add("@IsActiveOnMobile",aUser.IsActiveOnMobile);
					 vParams.Add("@ProfileImage",aUser.ProfileImage);
					 vParams.Add("@RegisteredDateTime",aUser.RegisteredDateTime);
					 vParams.Add("@LastConnection",aUser.LastConnection);
					 vParams.Add("@CreatedDateTime",aUser.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUser.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUser.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUser.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of User table.
		/// </summary>
		public UserDbEntity GetUser(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserDbEntity>("USP_UserSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the User table.
		/// </summary>
		 public IEnumerable<UserDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserDbEntity>("USP_UserSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
