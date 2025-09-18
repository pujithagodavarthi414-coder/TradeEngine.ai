using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class BranchRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Branch table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(BranchDbEntity aBranch)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBranch.Id);
					 vParams.Add("@CompanyId",aBranch.CompanyId);
					 vParams.Add("@BranchName",aBranch.BranchName);
					 vParams.Add("@CreatedDateTime",aBranch.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBranch.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBranch.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBranch.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_BranchInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Branch table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(BranchDbEntity aBranch)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBranch.Id);
					 vParams.Add("@CompanyId",aBranch.CompanyId);
					 vParams.Add("@BranchName",aBranch.BranchName);
					 vParams.Add("@CreatedDateTime",aBranch.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBranch.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBranch.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBranch.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_BranchUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Branch table.
		/// </summary>
		public BranchDbEntity GetBranch(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<BranchDbEntity>("USP_BranchSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Branch table.
		/// </summary>
		 public IEnumerable<BranchDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<BranchDbEntity>("USP_BranchSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
