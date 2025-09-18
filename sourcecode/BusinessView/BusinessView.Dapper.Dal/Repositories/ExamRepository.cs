using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ExamRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Exam table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ExamDbEntity aExam)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExam.Id);
					 vParams.Add("@StudentId",aExam.StudentId);
					 vParams.Add("@QuestionNo",aExam.QuestionNo);
					 vParams.Add("@QuestionId",aExam.QuestionId);
					 vParams.Add("@OptionNo",aExam.OptionNo);
					 vParams.Add("@CreatedDateTime",aExam.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aExam.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExam.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExam.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ExamInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Exam table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ExamDbEntity aExam)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aExam.Id);
					 vParams.Add("@StudentId",aExam.StudentId);
					 vParams.Add("@QuestionNo",aExam.QuestionNo);
					 vParams.Add("@QuestionId",aExam.QuestionId);
					 vParams.Add("@OptionNo",aExam.OptionNo);
					 vParams.Add("@CreatedDateTime",aExam.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aExam.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aExam.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aExam.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ExamUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Exam table.
		/// </summary>
		public ExamDbEntity GetExam(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ExamDbEntity>("USP_ExamSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Exam table.
		/// </summary>
		 public IEnumerable<ExamDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ExamDbEntity>("USP_ExamSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
