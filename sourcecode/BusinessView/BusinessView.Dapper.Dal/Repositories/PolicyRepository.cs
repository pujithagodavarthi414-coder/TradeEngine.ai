using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class PolicyRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Policy table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(PolicyDbEntity aPolicy)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPolicy.Id);
					 vParams.Add("@RefId",aPolicy.RefId);
					 vParams.Add("@Description",aPolicy.Description);
					 vParams.Add("@PdfFileBlobPath",aPolicy.PdfFileBlobPath);
					 vParams.Add("@WordFileBlobPath",aPolicy.WordFileBlobPath);
					 vParams.Add("@ReviewDate",aPolicy.ReviewDate);
					 vParams.Add("@CategoryId",aPolicy.CategoryId);
					 vParams.Add("@MustRead",aPolicy.MustRead);
					 vParams.Add("@CreatedDateTime",aPolicy.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPolicy.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPolicy.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPolicy.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PolicyInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Policy table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(PolicyDbEntity aPolicy)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aPolicy.Id);
					 vParams.Add("@RefId",aPolicy.RefId);
					 vParams.Add("@Description",aPolicy.Description);
					 vParams.Add("@PdfFileBlobPath",aPolicy.PdfFileBlobPath);
					 vParams.Add("@WordFileBlobPath",aPolicy.WordFileBlobPath);
					 vParams.Add("@ReviewDate",aPolicy.ReviewDate);
					 vParams.Add("@CategoryId",aPolicy.CategoryId);
					 vParams.Add("@MustRead",aPolicy.MustRead);
					 vParams.Add("@CreatedDateTime",aPolicy.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aPolicy.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aPolicy.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aPolicy.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_PolicyUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Policy table.
		/// </summary>
		public PolicyDbEntity GetPolicy(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<PolicyDbEntity>("USP_PolicySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Policy table.
		/// </summary>
		 public IEnumerable<PolicyDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<PolicyDbEntity>("USP_PolicySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Policy table by a foreign key.
		/// </summary>
		public List<PolicyDbEntity> SelectAllByCategoryId(Guid categoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CategoryId",categoryId);
				 return vConn.Query<PolicyDbEntity>("USP_PolicySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
