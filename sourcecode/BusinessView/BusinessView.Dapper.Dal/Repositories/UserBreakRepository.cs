using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserBreakRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserBreak table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserBreakDbEntity aUserBreak)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserBreak.Id);
					 vParams.Add("@UserId",aUserBreak.UserId);
					 vParams.Add("@Date",aUserBreak.Date);
					 vParams.Add("@IsOfficeBreak",aUserBreak.IsOfficeBreak);
					 vParams.Add("@BreakIn",aUserBreak.BreakIn);
					 vParams.Add("@BreakOut",aUserBreak.BreakOut);
					 int iResult = vConn.Execute("USP_UserBreakInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserBreak table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserBreakDbEntity aUserBreak)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserBreak.Id);
					 vParams.Add("@UserId",aUserBreak.UserId);
					 vParams.Add("@Date",aUserBreak.Date);
					 vParams.Add("@IsOfficeBreak",aUserBreak.IsOfficeBreak);
					 vParams.Add("@BreakIn",aUserBreak.BreakIn);
					 vParams.Add("@BreakOut",aUserBreak.BreakOut);
					 int iResult = vConn.Execute("USP_UserBreakUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserBreak table.
		/// </summary>
		public UserBreakDbEntity GetUserBreak(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserBreakDbEntity>("USP_UserBreakSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserBreak table.
		/// </summary>
		 public IEnumerable<UserBreakDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserBreakDbEntity>("USP_UserBreakSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
