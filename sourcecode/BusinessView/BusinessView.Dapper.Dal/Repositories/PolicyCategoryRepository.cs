using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PolicyCategoryRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the PolicyCategory table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PolicyCategoryDbEntity aPolicyCategory)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPolicyCategory.Id);
					 vParams.Add("@CategoryName",aPolicyCategory.CategoryName);
					 vParams.Add("@CreatedDateTime",aPolicyCategory.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPolicyCategory.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPolicyCategory.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPolicyCategory.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PolicyCategoryInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the PolicyCategory table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PolicyCategoryDbEntity aPolicyCategory)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPolicyCategory.Id);
					 vParams.Add("@CategoryName",aPolicyCategory.CategoryName);
					 vParams.Add("@CreatedDateTime",aPolicyCategory.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPolicyCategory.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPolicyCategory.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPolicyCategory.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PolicyCategoryUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of PolicyCategory table.
		/// </summary>
		public PolicyCategoryDbEntity GetPolicyCategory(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PolicyCategoryDbEntity>("USP_PolicyCategorySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the PolicyCategory table.
		/// </summary>
		 public IEnumerable<PolicyCategoryDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PolicyCategoryDbEntity>("USP_PolicyCategorySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
