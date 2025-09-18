using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class AssetCommentRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the AssetComment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(AssetCommentDbEntity aAssetComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aAssetComment.Id);
					 vParams.Add("@AssetId",aAssetComment.AssetId);
					 vParams.Add("@Comment",aAssetComment.Comment);
					 vParams.Add("@CreatedDateTime",aAssetComment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aAssetComment.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aAssetComment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aAssetComment.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_AssetCommentInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the AssetComment table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(AssetCommentDbEntity aAssetComment)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aAssetComment.Id);
					 vParams.Add("@AssetId",aAssetComment.AssetId);
					 vParams.Add("@Comment",aAssetComment.Comment);
					 vParams.Add("@CreatedDateTime",aAssetComment.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aAssetComment.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aAssetComment.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aAssetComment.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_AssetCommentUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of AssetComment table.
		/// </summary>
		public AssetCommentDbEntity GetAssetComment(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<AssetCommentDbEntity>("USP_AssetCommentSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the AssetComment table.
		/// </summary>
		 public IEnumerable<AssetCommentDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<AssetCommentDbEntity>("USP_AssetCommentSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the AssetComment table by a foreign key.
		/// </summary>
		public List<AssetCommentDbEntity> SelectAllByAssetId(Guid assetId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@AssetId",assetId);
				 return vConn.Query<AssetCommentDbEntity>("USP_AssetCommentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
