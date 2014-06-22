//
//  KRHebbianAlgorithm.swift
//  KRHebbianAlgorithm
//
//  Created by Kalvar on 2014/6/21.
//  Copyright (c) 2014年 Kalvar. All rights reserved.
//

import Foundation

class KRHebbianAlgorithm : NSObject
{
    //學習速率 ( eta )
    var theta : Float = 1.0;
    //初始權重陣列 ( 2 維, 未轉矩陣 )
    var weights       = Any[]();
    //初始參數陣列 ( 1 維 )
    var params        = Float[]();
    //運算完成的新權重 ( 1 維 )
    var deltaWeights  = Float[]();
    //轉置後的權重矩陣 ( N 維 )
    var _transposedWeights : Any[] = Any[]();
    
    /*
     * @pragma --mark Private Methods
     */
    /*
    * @ 累加( 轉置後的矩陣乘以另一個未轉置矩陣 ) ( 直 1 維 x 橫 1 維 )
    *
    *   - 赫賓是 1 維 x 1 維 ( 不需考慮 N 維 )
    *
    *   - 兩個矩陣必須滿足 A 矩陣的行數等於 B 矩陣的列數才可以相乘
    *
    *   - _multiplierMatrix   乘數 ( 轉置後的矩陣 )
    *
    *     @[ @[1], @[2], @[3] ]
    *
    *   - _multiplicandMatrix 被乘數
    *
    *     @[4, 5, 6]
    *
    */
    //func _sumTransposedMatrix(_transposedMatrix : Array<Array<Float>>!, _multiplicandMatrix : Float[]!) -> Float
    func _sumTransposedMatrix(_transposedMatrix : Any[], _multiplicandMatrix : Float[]!) -> Float
    {
        var _transposedCount : Int = 1;
        //When the _transposedMatrix : Any[], that we can do this :
        //if _transposedMatrix[0] is Float[]
        //as? Any[] 的原因 : 在 transposeMatrix() 進行轉置矩陣時，_newRows 是宣告成 Any[] 在作存取的。
        if let _subMatrix = _transposedMatrix[0] as? Any[]
        {
            //要先將子項目指定轉型給一個參數，才能進行其它相關操作，無法直接默認取用 ( 比 ObjC 麻煩不少 )
            //let _subMatrix : Float[] = _transposedMatrix[0] as Float[];
            _transposedCount         = _subMatrix.count;
        }
        
        var _multiplicandCount = _multiplicandMatrix.count;
        var _sum : Float       = 0.0;
        //轉置矩陣的長度
        //for var i=0; i<_transposedCount; i++
        for i in 0.._transposedCount
        {
            //被乘矩陣的長度
            for j in 0.._multiplicandCount
            {
                //避免 Exception for Crash
                if j > _transposedCount
                {
                    break;
                }
                //因為 _newRows 是 Any[] 型態，故這裡不可指定為 Float[]
                let _subTransMatrix : Any[]    = _transposedMatrix[j] as Any[];
                //Any[] 取出來的值直接使用 as 強轉型為 Float 才行，不可直接使用 Float() 來轉型，會 Crash
                let _transposedValue : Float   = _subTransMatrix[i] as Float;
                let _multiplicandValue : Float = Float(_multiplicandMatrix[j]);
                _sum += _transposedValue * _multiplicandValue;
            }
        }
        return _sum;
    }
    
    /*
    * @ 權重矩陣相加(矩陣一, 矩陣二, 標記)
    *   - _weightMatrix 是多維陣列
    */
    func _weightMatrix(_weightMatrix : Any[], _plusMatrix : Float[], _mark : Float) -> Float[]
    {
        var _sums : Float[]       = [];
        var _weightCount : Int    = _weightMatrix.count;
        var _subWeights : Float[] = [];
        if _weightCount < _plusMatrix.count
        {
            //代表 _weightMatrix 為多維陣列
            _subWeights  = _weightMatrix[0] as Float[];
            _weightCount = _subWeights.count;
        }
        
        if _mark > 0
        {
            for i in 0.._weightCount
            {
                var _weightValue : Float = Float(_subWeights[i]); //同 _weightMatrix[0][i] as Float;
                var _matrixValue : Float = Float(_plusMatrix[i]);
                //要存入陣列的值，一定要跟陣列的型態相同，否則 Error
                _sums.append( ( _weightValue + _matrixValue ) );
            }
        }
        
        if _mark < 0
        {
            for i in 0.._weightCount
            {
                var _weightValue : Float = Float(_subWeights[i]);
                var _matrixValue : Float = Float(_plusMatrix[i]);
                _sums.append( ( _weightValue - _matrixValue ) );
            }
        }
        return _sums;
    }
    
    /*
    * @ 求 SGN()
    */
    func _sgn(_sgnValue : Float) -> Int
    {
        return ( _sgnValue >= 0.0 ) ? 1 : -1;
    }
    
    /*
    * @ Step 1. 求出 Net
    * @ Step 2. 求出 sgn()
    *
    * @ 回傳 sgn()
    *
    */
    func _findFOfNet() -> Int
    {
        //W1 & X1
        let _net : Float = _sumTransposedMatrix(self._transposedWeights, _multiplicandMatrix : self.params);
        //回傳 sgn() 判定值
        return _sgn(_net);
    }
    
    /*
    * @ Step 3. 求 delta W (下一節點之權重值)
    */
    func _findNextDeltaWeightsWithFOfNet(_fOfNet : Int) -> Float[]
    {
        var _mark : Float = self.theta * Float(_fOfNet);
        return _weightMatrix(self.weights, _plusMatrix : self.params, _mark : _mark);
    }
    
    /*
    * @ 先轉置原始權重矩陣
    */
    func _transposeWeights()
    {
        self._transposedWeights = transposeMatrix( self.weights );
    }
    
    /*
     * @pragma --mark Public Methods
     */
    //Singleton
    class var sharedAlgorithm : KRHebbianAlgorithm
    {
        struct Singleton
        {
            static let instance : KRHebbianAlgorithm = KRHebbianAlgorithm();
        }
        println("sharedAlgorithm calling");
        return Singleton.instance;
    }
    
    init()
    {
        println("init calling");
        theta              = 0.0;
        weights            = [];
        params             = [];
        deltaWeights       = [];
        _transposedWeights = [];
    }
    
    /*
    * @ 轉置矩陣
    *   - 1. 傳入 1 維陣列
    *   - 2. 傳入 2 維陣列
    *   - 3. 傳入 N 維陣列
    */
    func transposeMatrix(_matrix : Any[]) -> Any[]
    {
        /*
        * @ 多維陣列要用多個 Array 互包來完成
        */
        if nil == _matrix
        {
            return Any[](); //Float[]();
        }
        
        var _transposedMatrix : Any[] = Any[]();
        var _xCount : Int             = _matrix.count;
        var _yCount : Int             = 0;
        
        //如果第 1 個值為陣列
        switch _matrix[0]
        {
            /*
            //可以判斷成功
            case is Double[], is Float[], is Int[], is Any[]:
                //但不知道該轉成何種型態，It doesn't work.
                let _firstMatrix = _matrix[0] as ???;
                _xCount = _firstMatrix.count;
                _yCount = _matrix.count;
            */
            case let _firstMatrix as Double[]:
                //即為 N 維陣列
                _xCount = _firstMatrix.count;
                _yCount = _matrix.count;
            
            case let _firstMatrix as Float[]:
                _xCount = _firstMatrix.count;
                _yCount = _matrix.count;
            
            case let _firstMatrix as Int[]:
                _xCount = _firstMatrix.count;
                _yCount = _matrix.count;
            
            case let _firstMatrix as Any[]:
                _xCount = _firstMatrix.count;
                _yCount = _matrix.count;
            
            default:
                _xCount = _matrix.count;
                _yCount = 0;
        }
        
        /*
        //這樣能在給定變數的同時，也給值，並且要用 as? 宣告為「不確定」是這型態，如確定是這型態就給值，不是這型態就給 nil 值。
        if let _firstMatrix = _matrix[0] as? Float[]
        {
            //即為 N 維陣列
            _xCount = _firstMatrix.count;
            _yCount = _matrix.count;
        }
        */
        
        //是 1 維陣列
        if _yCount == 0
        {
            for var x=0; x<_xCount; x++
            {
                _transposedMatrix.append( _matrix[x] );
            }
        }
        else
        {
            //是多維陣列
            for var x=0; x<_xCount; x++
            {
                //轉置，所以 x 總長度為 _yCount
                var _newRows : Any[] = Any[]();
                for var y=0; y<_yCount; y++
                {
                    NSLog("x = %i, y = %i", x, y);
                    //是陣列, 記得要指定陣列裡面值的「型態」，不可只單用 Any[] 妄想取代 Float[], Int[], AnyObject[] 等等陣列，而 Any[] 本身也是一種指定型態!
                    //只能用 switch 判斷型態嗎 ? 好麻煩 囧
                    switch _matrix[y]
                    {
                        /*
                        case is Double[], is Float[], is Int[], is Any[]:
                            let _subMatrix : Any[] = _matrix[y] as Any[];
                            _newRows.append( _subMatrix[x] );
                        */
                        case let _subMatrix as Double[]:
                            _newRows.append( _subMatrix[x] );
                        case let _subMatrix as Float[]:
                            _newRows.append( _subMatrix[x] );
                        case let _subMatrix as Int[]:
                            _newRows.append( _subMatrix[x] );
                        case let _subMatrix as Any[]:
                            _newRows.append( _subMatrix[x] );
                        default:
                            _newRows.append( _matrix[y] );
                    }
                    /*
                    if let _subMatrix = _matrix[y] as? Float[]
                    {
                        _newRows.append( _subMatrix[x] );
                    }
                    else
                    {
                        _newRows.append( _matrix[y] );
                    }
                    */
                }
                println("_newRows : \(_newRows)");
                //這裡要用 _newRows.unshare() 或 .copy() 來確保加入 Array 裡的值是不會連帶受影響的，否則會 Error : swift failed with exit code 254
                _transposedMatrix.append( _newRows.copy() );
            }
        }
        return _transposedMatrix;
    }
    
    /*
    * @ 再執行 Hebbian
    *   - 求出 f(net) 並轉換成 sgn
    */
    func training() -> Float[]
    {
        _transposeWeights();
        self.deltaWeights = _findNextDeltaWeightsWithFOfNet( _findFOfNet() );
        return deltaWeights;
    }
    
}
