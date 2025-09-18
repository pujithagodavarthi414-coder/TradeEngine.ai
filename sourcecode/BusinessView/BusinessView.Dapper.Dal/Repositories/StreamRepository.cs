using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class StreamRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Stream table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(StreamDbEntity aStream)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStream.Id);
					 vParams.Add("@StreamName",aStream.StreamName);
					 vParams.Add("@CreatedDateTime",aStream.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStream.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStream.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStream.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StreamInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Stream table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(StreamDbEntity aStream)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aStream.Id);
					 vParams.Add("@StreamName",aStream.StreamName);
					 vParams.Add("@CreatedDateTime",aStream.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aStream.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aStream.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aStream.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_StreamUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Stream table.
		/// </summary>
		public StreamDbEntity GetStream(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<StreamDbEntity>("USP_StreamSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Stream table.
		/// </summary>
		 public IEnumerable<StreamDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<StreamDbEntity>("USP_StreamSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
