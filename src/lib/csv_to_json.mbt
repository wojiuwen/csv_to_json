// 最简单的文件读取示例
fn read(path:String)->String{
    try{
      return @fs.read_file_to_string(path)
    } catch{
      @fs.IOError(e)=>{
        println(e)
      }
    }
    return "error"
}

fn csv_to_json_s(csv_content: String) -> String {
    // 按行分割CSV内容
    let lines = csv_content.split("\n").collect()

    // 检查是否有足够的行
    if lines.length()<2{
      return "[]"
    }

    // 获取标题行并分割
    let header_line = lines[0]
    let headers = header_line.split(",").collect()
    
    // 初始化JSON结果，开始数组
    let mut json_result="[" 
    
    // 遍历所有数据行
    for i=1;i<lines.length();i=i+1{
           let line =lines[i]
           
           // 跳过空行
           
           // 分割字段
           let fields =line.split(",").collect()
           
           // 添加对象间的逗号（除了第一个对象）
           if i > 1 {
               json_result = json_result + ","
               
           }
           
           // 开始一个JSON对象
           json_result=json_result+"{"
           // 遍历标题，确保不越界访问fields数组
           for j=0;j<headers.length() && j < fields.length() ;j=j+1{
            // 添加键值对，修复引号格式
            if(j<headers.length() && j < fields.length()){
            let str1=headers[j].to_string()
             let view1 = str1.view(start_offset = str1.offset_of_nth_char(0).unwrap(),end_offset = str1.offset_of_nth_char(str1.length()-1).unwrap())

             let str2=fields[j].to_string()
             let view2 = str2.view(start_offset = str2.offset_of_nth_char(0).unwrap(),end_offset = str2.offset_of_nth_char(str2.length()-1).unwrap())
             json_result=json_result+ "\"" + view1.to_string() + "\"" +":"+ "\""+ view2.to_string() + "\""
            }
            
                    

            // 添加字段间的逗号（如果不是最后一个字段）
            if j < headers.length() - 1  {
                json_result = json_result + ","
            }

           }
           
           
           // 结束JSON对象
           json_result = json_result + "}"
    }
    

    // 结束JSON数组
    json_result = json_result + "]"
    
    return json_result
}

pub fn csv_to_json(path:String) -> Unit {
    let csv_content=read(path)
    let json_path=path+".json"
    let json_str=csv_to_json_s(csv_content)
    
   try{ @fs.write_string_to_file(json_path.to_string(),json_str.to_string())}
   catch{
    @fs.IOError(e)=>{
      println(e)
    }
   }
}


fn main {
  
}