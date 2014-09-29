# Преобразование строковых ключей в символьные
# из { "key" => 123, "inner_hash" => { "another_key" => "blabla" }}
# в  {:key=>123, :inner_hash=>{:another_key=>"blabla"}}
#
# HashTransform.keys_to_symbols(hash)
#
class HashTransform
  #take keys of hash and transform those to a symbols
  def self.keys_to_symbols(value)
    return value if not value.is_a?(Hash)
    hash = value.inject({}){|memo,(k,v)| memo[k.to_sym] = HashTransform.keys_to_symbols(v); memo}
    return hash
  end
end