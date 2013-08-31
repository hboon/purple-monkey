#  Derived from https://github.com/mailchimp/ChimpKit2/blob/master/Core/Classes/ChimpKit.m

#  Copyright 2013 Yar Hwee Boon. All rights reserved.
#  
#  All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#  
#  * Redistributions of source code must retain the above copyright
#  notice, this list of conditions and the following disclaimer.
#  
#  * Redistributions in binary form must reproduce the above copyright
#  notice, this list of conditions and the following disclaimer in the
#  documentation and/or other materials provided with the distribution.
#  
#  * Neither the name of MotionObj nor the names of its
#  contributors may be used to endorse or promote products derived from
#  this software without specific prior written permission.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
#  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
#  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
#  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
#  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

class PurpleMonkey
  attr_accessor :api_key

  def initialize(key)
    self.api_key = key
  end


  def call_api_method(method, params:params)
    url = "#{api_url}#{method}"
    data = encode_request_params(params)

    request = NSMutableURLRequest.requestWithURL(NSURL.URLWithString(url))
    request.setHTTPMethod('POST')
    request.setTimeoutInterval(5)
    request.setHTTPBody(data)
    handler = block_given? ? Proc.new: nil
    NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue, completionHandler:proc {|response, data, error|
      if error.nil?
        #results might be Hash or just true/false
        results = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments, error:nil)
        #p "Response: #{response}  #{results}"
        handler.call(results, nil) unless handler.nil?
      else
        #p "Error: #{error}"
        handler.call(nil, error) unless handler.nil?
      end
    })

  end


  def api_url
      "https://#{api_key.split('-')[1]}.api.mailchimp.com/1.3/?method="
  end


  def encode_request_params(params)
    post_body_params = {}
    post_body_params['apikey'] = api_key unless api_key.nil?
    post_body_params.merge! params unless params.nil?
    json_encoded = encode_string(NSString.alloc.initWithData(NSJSONSerialization.dataWithJSONObject(post_body_params, options:0, error:nil), encoding:NSUTF8StringEncoding))
    NSMutableData.dataWithData(json_encoded.dataUsingEncoding(NSUTF8StringEncoding))
  end


  def encode_string(s)
    CFURLCreateStringByAddingPercentEscapes(nil, s, nil, "!*'();:@&=+$,/?%#[]", KCFStringEncodingUTF8)
  end
end
