class WorldCovidStatus::Util
    def self.left_align(str)
        tailing_space =""
        if str.length < 10 
          (10-str.length).times{tailing_space << " "}     
        end
        indented_str = str + tailing_space
    end 
      
    def self.right_align(str)
        leading_space = ""
        if str.length < 10
            (10-str.length).times{leading_space << " "}
        end
        indented_str = leading_space + str
    end 

    def self.font_color(str, color)
        if color == "yellow"
            prefix="\033[33m"
            suffix="\033[00m"
        elsif color == "red"  
            prefix="\033[31m"
            suffix="\033[00m"
        elsif color == "blue"  
            prefix="\033[34m"
            suffix="\033[00m"                
        end    
        str =  prefix + str.to_s + suffix   
    end   
    
end    