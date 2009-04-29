#  redis_intro.rb
#  
#  Created by Michelangelo Altamore on 2009-04-28.
#  Copyright 2009 Convergent.it. All rights reserved.
#

require 'rubygems'
require 'redis'

r = Redis.new

p 'CHIAVE-VALORE'

r['user:michelangelo:id'] = '1000'  # SET user:michelangelo:id 1000
r['user:michelangelo:id']           # GET user:michelangelo:id  

r['user:michel:id'] = '1001'       # SET user:michel:id 1001
r['user:michel:id']                # GET user:michel:id 

# Osserva che il : fa da separatore per namespacing delle chiavi
# poteva anche essere un / , - , etc..

puts

p 'CONTATORI'

r.delete 'user_id'          # DEL user_id
r.set('user_id', 0)         # SET user_id 0
r['user_id']                #  => 0

r.incr('user_id', 1000)     # INCRBY user_id integer
r['user_id']                #  => 1000

r.incr('user_id')           # INCR user_id 
r['user_id']                #  => 1001
                            
r.incr('user_id')           # incrementiamo il contatore globale 
r['user_id']                #  => 1002

r['user:alessandro:id'] = r['user_id']  # SET user:alessandro:id 1002
r['user:alessandro:id']                 # => 1002

r.delete 'user:alessandro:id' # DEL user:alessandro:id

r.decr('user_id')             # DECR  user_id
r['user_id']                  #  => 1001

puts

p 'INSIEMI'

r.set_add 'user:michelangelo:barcamp2009:tags', 'redis'
r.set_add 'user:michelangelo:barcamp2009:tags', 'storage'
r.set_add 'user:michelangelo:barcamp2009:tags', 'data structure'
r.set_add 'user:michelangelo:barcamp2009:tags', 'web 3.0'

r.set_members 'user:michelangelo:barcamp2009:tags'
# => #<Set: {"data structure", "redis", "storage", "web 3.0"}>

r.set_add 'user:michel:barcamp2009:tags', 'semantic web'
r.set_add 'user:michel:barcamp2009:tags', 'ontology'
r.set_add 'user:michel:barcamp2009:tags', 'rdf/owl'
r.set_add 'user:michel:barcamp2009:tags', 'web 3.0'

r.set_members 'user:michel:barcamp2009:tags'
# => <Set: {"rdf/owl", "semantic web", "ontology", "web 3.0"}>

p 'intersezione'
r.set_intersect 'user:michelangelo:barcamp2009:tags', 'user:michel:barcamp2009:tags' 
# => #<Set: {"web 3.0"}>

puts

p 'LISTE'

r.delete 'coda' # inizializza il buffer della coda di messaggi

# produttore 
r.push_tail 'coda', 'vino'  # => "OK"
r.push_tail 'coda', 'acqua' # => "OK"

# consumatore
r.pop_head 'coda' # => "vino"

# arriva l'antipasto :)
r.push_tail 'coda', 'pane'      # => "OK"
r.push_tail 'coda', 'olive'     # => "OK"
r.push_tail 'coda', 'caponata'  # => "OK"

# consumatore
r.pop_head 'coda' # => "acqua"
r.pop_head 'coda' # => "pane"

# il condimento arriva in ritardo..
r.push_tail 'coda', 'olio'  # => "OK"

r.pop_head 'coda' # => "olive"
r.pop_head 'coda' # => "caponata"
r.pop_head 'coda' # => "olio"

r.pop_head 'coda' #  => nil non e' rimasto piu' nulla :)
